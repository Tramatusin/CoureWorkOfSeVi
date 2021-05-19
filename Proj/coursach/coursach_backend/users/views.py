# from django.contrib.auth.models import User
from django.http import JsonResponse
from rest_framework import serializers
from django.shortcuts import render, redirect
from django.contrib import messages
from django.utils.baseconv import base64
from django.views.decorators.csrf import csrf_exempt
from django.core.validators import validate_email
from django.core.exceptions import ValidationError
from django.contrib.auth import authenticate
from .forms import UserRegisterForm

import json
import requests

from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys

import time
from bs4 import BeautifulSoup

from fake_useragent import UserAgent
from time import sleep
from multiprocessing.pool import ThreadPool as Pool
from pathlib import Path

import os
import base64

from django.contrib.auth import get_user_model
User = get_user_model()


manga_path = "D:\\manga\\"
source_path = "https://mangalib.me/"

@csrf_exempt
def register(request):
    if request.method == 'POST':
        form = UserRegisterForm(request.POST)

        if form.is_valid():
            form.save()
            username = form.cleaned_data.get('username')
            messages.success(request, f'Account created for {username}!')
            return redirect('home-ref')
    else:
        form = UserRegisterForm()
    return render(request, 'users/register.html', {'form': form})


def get_image_bytes(file_path):
    with open(file_path, "rb") as image_file:
        encoded_string = base64.b64encode(image_file.read())

    return encoded_string


def create_folder(path):
    Path(path).mkdir(parents=True, exist_ok=True)


def download_cover(url, path):
    try:
        driver = get_driver_with_random_ua()
        file = open(path, "wb")
        driver.get(url)
        file.write(driver.find_element_by_css_selector("img").screenshot_as_png)
        file.close()
    finally:
        driver.quit()


def download_image(url, path):
    print("download_image")

    response = requests.get(url)
    file = open(path, "wb")
    file.write(response.content)
    file.close()


def concat_url(code, volume, chapter):
    return source_path + code + "/v" + str(volume) + "/c" + str(chapter)


def get_driver_with_random_ua():
    options = Options()
    ua = UserAgent()
    user_agent = ua.random
    options.add_argument(f'user-agent={user_agent}')

    options.add_argument('--headless')
    options.add_argument('--no-sandbox')
    options.add_argument('--window-size=1920,1080')

    driver = webdriver.Chrome(options=options, executable_path='./chromedriver')

    return driver


def worker_downloader(i, code, volume, chapter, urls):
    try:
        print("worker_downloader")
        url = concat_url(code, volume, chapter)

        modified_url = url + f"?page={i}"

        driver = get_driver_with_random_ua()
        driver.get(modified_url)

        html = driver.page_source

        soup = BeautifulSoup(html, 'html.parser')
        res = (soup.find_all("div", class_="reader-view__wrap")[i - 1]).find("img").get("src")
        urls.append((res, i))

        download_image(res, manga_path + code + f"\\volume_{volume}" + f"\\chapter_{chapter}" + f"\\page_{i}.png")

        driver.quit()
    finally:
        driver.quit()


def get_chapter(code, volume, chapter):
    url = concat_url(code, volume, chapter)

    try:
        driver = get_driver_with_random_ua()
        driver.get(url)

        html = driver.page_source

        driver.quit()
    except:
        print("Driver error")
        driver.quit()
        exit(1)

    soup = BeautifulSoup(html, 'html.parser')
    res = soup.find_all("div", class_="reader-view__wrap")

    page_counter = 0
    for r in res:
        if page_counter < int(r.get("data-p")):
            page_counter = int(r.get("data-p"))

    create_folder(manga_path + code)
    create_folder(manga_path + code + f"\\volume_{volume}")
    create_folder(manga_path + code + f"\\volume_{volume}" + f"\\chapter_{chapter}")

    pool = Pool(page_counter if page_counter <= 15 else 15)

    urls_raw = []
    for i in range(1, page_counter + 1):
        pool.apply_async(worker_downloader, (i, code, volume, chapter, urls_raw))

    pool.close()
    pool.join()

    urls_raw.sort(key=lambda x: x[1])

    urls = []
    for url in urls_raw:
        urls.append(url[0])

    response = {
        "total_pages": page_counter,
        "pages": urls
    }

    with open(manga_path + code + f"\\volume_{volume}" + f"\\chapter_{chapter}" + "\\pages.json", 'w') as outfile:
        json.dump(response, outfile)


    f = open(manga_path + code + f"\\volume_{volume}" + f"\\chapter_{chapter}" + f"\\pages_total.txt", "w")
    f.write(str(page_counter))
    f.close()


def get_image_path(code, volume, chapter, page):
    return manga_path + code + f"\\volume_{volume}" + f"\\chapter_{chapter}" + f"\\page_{page}.png"


def is_image_downloaded(code, volume, chapter, page):
    return Path(get_image_path(code, volume, chapter, page)).is_file()


@csrf_exempt
def get_manga_page(request):
    json_data = json.loads(request.body)

    code = json_data["code"]
    volume = json_data["volume"]
    chapter = json_data["chapter"]
    page = json_data["page"]

    if not is_image_downloaded(code, volume, chapter, page):
        get_chapter(code, volume, chapter)

    f = open(manga_path + code + f"\\volume_{volume}" + f"\\chapter_{chapter}" + f"\\pages_total.txt", "r")
    total_pages = int(f.read())
    f.close()

    response = {
        "image": "{}".format(get_image_bytes(get_image_path(code, volume, chapter, page))),
        "total_pages": total_pages
    }

    return JsonResponse(response)


@csrf_exempt
def get_manga_page_urls(request):
    json_data = json.loads(request.body)

    code = json_data["code"]
    volume = json_data["volume"]
    chapter = json_data["chapter"]

    if not Path(manga_path + code + f"\\volume_{volume}" + f"\\chapter_{chapter}" + "\\pages.json").is_file():
        get_chapter(code, volume, chapter)

    json_file = open(manga_path + code + f"\\volume_{volume}" + f"\\chapter_{chapter}" + "\\pages.json", )
    response = json.load(json_file)
    json_file.close()

    return JsonResponse(response)


def parse_chapter_info(s):
    if s.find("-") != -1:
        name = s.split("-")[1].strip()
        volume_and_chapter_num = s.split("-")[0].strip()
    else:
        name = ''
        volume_and_chapter_num = s.strip()

    volume_num = volume_and_chapter_num.split(" ")[1]
    chapter_num = volume_and_chapter_num.split(" ")[3]

    chapter_dict = {
        "volume": int(volume_num),
        "chapter": float(chapter_num),
        "name": name
    }

    return chapter_dict


def get_manga_logic(code):
    if Path(manga_path + code + "\\info.json").is_file():
        json_file = open(manga_path + code + "\\info.json",)
        response = json.load(json_file)
        json_file.close()

        return response

    try:
        driver = get_driver_with_random_ua()
        driver.get(f"https://mangalib.me/{code}?section=info")

        html = driver.page_source

        soup = BeautifulSoup(html, 'html.parser')

        age_restriction = None
        if soup.find("div", class_="media-info-list__value text-danger") is not None:
            age_restriction = soup.find("div", class_="media-info-list__value text-danger").text

        if age_restriction is not None and age_restriction == "18+":
            return None

        name = soup.find("meta", itemprop="name").get("content")

        if soup.find("meta", itemprop="description") is None:
            return None
        description = soup.find("meta", itemprop="description").get("content")
        tags_raw = soup.find("div", class_="media-tags").find_all("a")
        url = soup.find("div", class_="media-sidebar__cover paper").find("img").get("src")
        create_folder(manga_path + code)

        download_cover(url, manga_path + code + f"\\cover.png")
        image_base64 = get_image_bytes(manga_path + code + f"\\cover.png")

        rating_value = soup.find("meta", itemprop="ratingValue").get("content")
        rating_count = soup.find("meta", itemprop="ratingCount").get("content")

        tags = []
        for tag in tags_raw:
            tags.append(tag.text)

    finally:
        driver.quit()


    try:
        driver = get_driver_with_random_ua()
        driver.maximize_window()
        driver.get(f"https://mangalib.me/{code}/v1/c1?page=1")
        try:
            elem = driver.find_element_by_css_selector("div.reader-header-actions:nth-child(3) > div:nth-child(2)")
            elem.click()
            html = driver.page_source
        except:
            elem = None

    finally:
        driver.quit()

    if elem is not None:
        soup = BeautifulSoup(html, 'html.parser')
        chapters_raw = soup.find_all("a", class_="menu__item text-truncate")

        chapters = []
        for chapter in chapters_raw:
            chapter_info = chapter.text
            try:
                chapters.append(parse_chapter_info(chapter_info))
            except:
                print(chapter_info)
    else:
        chapters = []

    response = {
        "name": f"{name}",
        "description": f"{description}",
        "tags": tags,
        "cover": f"{image_base64}",
        "rating_value": f"{rating_value}",
        "rating_count": f"{rating_count}",
        "chapters": chapters
    }

    with open(manga_path + code + "\\info.json", 'w') as outfile:
        json.dump(response, outfile)

    return response


@csrf_exempt
def get_manga(request):
    print("get_manga")

    json_data = json.loads(request.body)
    code = json_data["code"]

    r = get_manga_logic(code)

    return JsonResponse(r)


@csrf_exempt
def get_list(request):
    list = {
        "Клинок, рассекающий демонов": "kimetsu-no-yaiba",
        "Моя геройская академия": "boku_no_hero_academia",
        "Ванпанчмен": "onepunchman",
        "Магическая битва": "jujutsu-kaisen",
        "Кагуя хочет, чтобы ей признались: Гении - война любви и разума": "kaguya-sama-wa-kokurasetai-tensai-tachi-no-renai-zunousen",
    }

    return JsonResponse(list)


def crop_url(url):
    return url.split("/")[-1]


@csrf_exempt
def get_ongoings(request):
    if Path(manga_path + "\\ongoings.json").is_file():
        json_file = open(manga_path + "\\ongoings.json",)
        response = json.load(json_file)
        json_file.close()

        return JsonResponse(response)

    driver = get_driver_with_random_ua()

    driver.get(source_path)

    ongoings_raw = driver.find_element_by_css_selector("div.aside__panel:nth-child(4)")\
                         .find_elements_by_class_name("manga-list-item")

    codes = []
    ongoings = []
    for ongoing in ongoings_raw:
        href = ongoing.get_attribute("href")
        r = get_manga_logic(crop_url(href))
        if r is not None:
            codes.append(crop_url(href))
            ongoings.append(r)
        print("alive")

    response = {
        "codes": codes,
        "ongoings": ongoings
    }

    with open(manga_path + "\\ongoings.json", 'w') as outfile:
        json.dump(response, outfile)

    return JsonResponse(response)


@csrf_exempt
def get_new_manga(request):
    if Path(manga_path + "\\new_manga.json").is_file():
        json_file = open(manga_path + "\\new_manga.json",)
        response = json.load(json_file)
        json_file.close()

        return JsonResponse(response)

    driver = get_driver_with_random_ua()

    driver.get(source_path)

    new_manga_raw = driver.find_element_by_css_selector("div.aside__panel:nth-child(5)")\
                          .find_elements_by_class_name("manga-list-item")

    codes = []
    new_manga = []
    for manga in new_manga_raw:
        href = manga.get_attribute("href")
        r = get_manga_logic(crop_url(href))
        if r is not None:
            codes.append(crop_url(href))
            new_manga.append(r)
        print("alive")

    response = {
        "codes": codes,
        "new_manga": new_manga
    }

    with open(manga_path + "\\new_manga.json", 'w') as outfile:
        json.dump(response, outfile)

    return JsonResponse(response)


@csrf_exempt
def post_register(request):
    json_data = json.loads(request.body)

    username = json_data["username"]
    email = json_data["email"]

    password = json_data["password"]

    if not validate_post_email(email):
        response = {
            "status": "ERROR",
            "description": "Некорректный email адрес"
        }

        return JsonResponse(response)

    if not username_present(username, email):
        response = {
            "status": "OK",
            "description": "Пользователь успешно зарегестрирован"
        }

        User.objects.create_user(username=username,
                                 email=email,
                                 password=password)
    else:
        response = {
            "status": "ERROR",
            "description": "Пользователь с таким никнеймом или почтой уже существует!"
        }

    return JsonResponse(response)


@csrf_exempt
def post_auth(request):
    json_data = json.loads(request.body)

    username = json_data["username"]
    password = json_data["password"]

    user = authenticate(username=username, password=password)

    if user is not None:
        response = {
            "status": "OK",
            "description": "Успешная авторизация"
        }
    else:
        response = {
            "status": "ERROR",
            "description": "Неправильный никнейм или пароль"
        }

    return JsonResponse(response)


@csrf_exempt
def post_change_password(request):
    json_data = json.loads(request.body)

    username = json_data["username"]
    password = json_data["password"]
    new_password = json_data["new_password"]

    user = authenticate(username=username, password=password)

    if user is not None:
        user.set_password(new_password)
        user.save()

        response = {
            "status": "OK",
            "description": "Пароль был успешно сменен"
        }
    else:
        response = {
            "status": "ERROR",
            "description": "Неправильный никнейм или пароль"
        }

    return JsonResponse(response)


@csrf_exempt
def set_favourite_manga(request):
    json_data = json.loads(request.body)

    username = json_data["username"]
    password = json_data["password"]
    manga = json_data["manga"]

    user = authenticate(username=username, password=password)

    if user is not None:
        user_json = {
            "manga": manga
        }

        user.favourite_manga = user_json
        user.save()

        response = {
            "status": "OK",
            "description": "Любимая манга успешно сохранена"
        }
    else:
        response = {
            "status": "ERROR",
            "description": "Неправильный никнейм или пароль"
        }

    return JsonResponse(response)


@csrf_exempt
def get_favourite_manga(request):
    json_data = json.loads(request.body)

    username = json_data["username"]
    password = json_data["password"]

    user = authenticate(username=username, password=password)

    if user is not None:
        data = user.favourite_manga
        if len(data) > 0:
            manga = data["manga"]
        else:
            manga = []
        response = {
            "status": "OK",
            "manga": manga
        }
    else:
        response = {
            "status": "ERROR",
            "description": "Неправильный никнейм или пароль"
        }

    return JsonResponse(response)


def username_present(username, email):
    if User.objects.filter(username=username).exists():
        return True

    if User.objects.filter(email=email).exists():
        return True

    return False


def validate_post_email(email):
    try:
        validate_email(email)
        return True
    except ValidationError:
        return False
