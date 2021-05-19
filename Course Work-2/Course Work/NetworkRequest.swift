//
//  NetworkRequest.swift
//  Course Work
//
//  Created by Виктор Поволоцкий on 23.04.2021.
//
import UIKit
import Foundation
import Kanna
import SwiftyJSON

class NetworkRequest{
    let showErr = ErrorPres()
    var flag: Bool?
    
    func registrationOk(_ nickName: String?,
                              _ email: String?,
                              _ password: String?,
                              _ passwordConfirm: String?,
                              _ viewController: UIViewController)->Bool{
        if viewController is SignInViewController {
            if nickName == nil
                || nickName == ""
                || email == nil
                || email == ""
                || password == nil
                || password == ""
                || passwordConfirm == nil
                || passwordConfirm == ""
            {
                showErr.showError("Не все поля заполнены",viewController)
                return false
            }
            return true
        }
        else{
            if nickName == nil
            || nickName == ""
            || password == nil
            || password == ""{
                showErr.showError("Не все поля заполнены", viewController)
                return false
            }
            return true
        }
    }
    
    func checkPassword(_ password: String?,
                       _ viewController: UIViewController)->Bool{
        if password?.count ?? 0 >= 8 {
            return true
        }
        showErr.showError("Пароль не может содержать меньше 8 символов", viewController)
        return false
    }
    
    func postUserDataRegister(_ nickName: String,
                      _ email: String?,
                      _ password: String,
                      _ passwordConfirm: String?,
                      _ vc: UIViewController){
        
        if vc is SignInViewController{
            if password == passwordConfirm && registrationOk(nickName,email,password,passwordConfirm,vc) && checkPassword(password,vc){
                postReq("http://hsemanga.ddns.net:7000/register/post/", buildJsonRegister(nickName, email, password, passwordConfirm, vc: vc), vc: vc)
            }
        }else if registrationOk(nickName, nil, password, nil, vc) && checkPassword(password, vc){
                postReq("http://hsemanga.ddns.net:7000/authenticate/",buildJsonRegister(nickName, nil, password, nil, vc: vc), vc: vc)
        }
    }
    
    func buildJsonRegister(_ nickName: String?,
                   _ email: String?,
                   _ password: String?,
                   _ passwordConfirm: String?,
                   vc: UIViewController)->Data?{
        let jsonUser:[String:Any]
        if vc is SignInViewController {
            jsonUser =
                ["username":nickName!,
                 "email":email!,
                 "password":password!]
        }else{
            jsonUser =
                ["username":nickName!,
                 "password":password!]
        }

        if JSONSerialization.isValidJSONObject(jsonUser) {
            let jsonObj = try? JSONSerialization.data(withJSONObject: jsonUser, options: [])
            return jsonObj
        }
        return nil
    }
    
    func postReq(_ urlPOST: String,_ jsonData: Data?, vc: UIViewController){
        guard let url = URL(string: urlPOST) else {return}
        var postRequest = URLRequest(url: url)
        postRequest.httpMethod = "POST"
        postRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        postRequest.httpBody = jsonData
        
        URLSession.shared.dataTask(with: postRequest){
            [weak self, vc]
            (data,response,error) in
            if let data = data{
                let jsonObj = try? JSONSerialization.jsonObject(with: data)
                guard
                    let json = jsonObj as? [String:Any],
                    let status = json["status"] as? String,
                    let descrip = json["description"] as? String
                else {
                    print("invalid json Data")
                    return
                }
                DispatchQueue.main.async {
                    if status == "OK"{
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationFromGetAuthData"), object: nil, userInfo: ["status":true])
                    }else{
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationFromGetAuthData"), object: nil, userInfo: ["status":false])
                        self?.showErr.showError(descrip, vc)
                    }
                }
            }else{
                self?.showErr.showError("Ошибка в запросе, не могу передать данные", vc)
            }
        }.resume()
    }
    
    
    func parseNews(urlStr: String,completion:  @escaping ([News])-> Void){
        var titles: [String] = []
        var image: [String] = []
        //var shortdiscription: [String] = []
        var linksOfNews:[String] = []
        var listOfNews: [String] = []
        var listOfDates: [String] = []
        var listOfNewsObject: [News] = []
        
        getDataOnHTML(titles: &titles, image: &image, linksOfNews: &linksOfNews, listOfNews: &listOfNews, listOfDates: &listOfDates, urlHTML: urlStr)
        
        for i in 0..<listOfNews.count{
            listOfNewsObject.append(News(title: titles[i], linkOfImage: image[i], fullNewsText: listOfNews[i], datePub: listOfDates[i]))
        }
        completion(listOfNewsObject)
    }
    
    func getDataOnHTML(titles: inout [String],
                       image: inout [String],
                       linksOfNews: inout [String],
                       listOfNews: inout [String],
                       listOfDates: inout [String],
                       urlHTML: String){
        guard let url = URL(string: urlHTML) else {return}
        if let doc = try? HTML(url: url, encoding: .utf8){
            for data in doc.css("div.col-md-6 > a > img"){
                titles.append(data["title"]!)
                image.append(data["data-original"]!)
            }
//            for shortDiscrp in doc.css("div.news-summary") {
//                shortdiscription.append(shortDiscrp.text!)
//            }
            for link in doc.css("div.col-md-6 > a"){
                linksOfNews.append(link["href"]!)
            }
            for date in doc.css("div.col-md-6 > div.desc > div.details > span"){
                listOfDates.append(date["title"]!)
            }
        }
        for news in linksOfNews{
            guard let url = URL(string: news) else {return}
            if let new = try? HTML(url: url, encoding: .utf8){
                for textNew in new.css("div.news-full > div.description"){
                        listOfNews.append(textNew.text!)
                }
            }
        }
    }
    
    
    func buildJsonOfPage(_ code: String?,
                         _ volume: Int,
                         _ chapter: Double,
                         _ page: Int)->Data?{
        let jsonUser:[String:Any]
        jsonUser = ["code": code!,
                    "volume": volume,
                    "chapter": chapter,
                    "page": page]
        if JSONSerialization.isValidJSONObject(jsonUser) {
            let jsonObj = try? JSONSerialization.data(withJSONObject: jsonUser)
            return jsonObj
        }
        return nil
    }
    
    func getPageOfChapterOfManga(jsonData: Data?, completition: @escaping ([Data])->()){
        guard let url = URL(string: "http://hsemanga.ddns.net:7000/getmanga/chapter/")else{return}
        var postReq = URLRequest(url: url)
        postReq.httpMethod = "POST"
        postReq.addValue("application/json", forHTTPHeaderField: "Content-Type")
        postReq.httpBody = jsonData
        
        URLSession.shared.dataTask(with: postReq, completionHandler: {
            (data,response,error) in
            if error != nil{
                print(error!)
            }
            if let dataRes = data{
                let json = try? JSON(data: dataRes)
                let pages = json?["pages"].arrayValue.map({$0.stringValue})
                var datas: [Data] = []
                DispatchQueue.global().async {
                    if let urlofpage = pages{
                        for item in urlofpage{
                            guard let url = URL(string: item) else {return}
                            datas.append(try! Data(contentsOf: url))
                        }
                    }
                    DispatchQueue.main.async {
                        completition(datas)
                    }
                }
            }
        }).resume()
    }
}
