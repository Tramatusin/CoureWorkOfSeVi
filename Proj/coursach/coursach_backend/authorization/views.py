from django.shortcuts import render
from django.http import HttpResponse


def authorization(request):
    # return HttpResponse('<h1>Home</h1>')
    return render(request, 'authorization/authForm.html')


def home(request):
    # return HttpResponse('<h1>Home</h1>')
    return render(request, 'authorization/home.html')