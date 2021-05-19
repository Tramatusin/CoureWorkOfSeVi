//
//  ProjectExtansions.swift
//  Course Work
//
//  Created by Виктор Поволоцкий on 02.05.2021.
//

import Foundation
import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
                else{
                    // Отображение ихображения по умолчанию
                    DispatchQueue.main.async {
                        self?.image = UIImage(named: "defaultStockImage.png")
                    }
                }
            } else{
                // Отображение ихображения по умолчанию
                DispatchQueue.main.async {
                    self?.image = UIImage(named: "defaultStockImage.png")
                }
            }
        }
    }
    
    func loadOnData(data: Data){
        if let image = UIImage(data: data) {
            DispatchQueue.main.async {
                self.image = image
            }
        }
        else{
            // Отображение ихображения по умолчанию
            DispatchQueue.main.async {
                self.image = UIImage(named: "defaultStockImage.png")
            }
        }
    }
    
    func loadPage(_ dataForImage: Data?){
        guard let url = URL(string: "http://hsemanga.ddns.net:7000/getmanga/page/")else{return}
        var postReq = URLRequest(url: url)
        postReq.httpMethod = "POST"
        postReq.addValue("application/json", forHTTPHeaderField: "Content-Type")
        postReq.httpBody = dataForImage
        
        URLSession.shared.dataTask(with: postReq, completionHandler: {
            [weak self]
            (data,response,error) in
            
            if error != nil{
                print(error)
            }
            if let dataRes = data{
                let jsonObj = try? JSONSerialization.jsonObject(with: dataRes)
                guard
                    let json = jsonObj as? [String: Any],
                    let image = json["image"] as? String
                else{
                    print("invalid data json")
                    return
                }
                DispatchQueue.main.async {
                    let start = image.index(image.startIndex, offsetBy: 2)
                    let end = image.index(image.endIndex, offsetBy: -1)
                    let range = start..<end
                    let newSubstring: String = String(image[range])
                    let imageData = Data(base64Encoded: newSubstring, options: .ignoreUnknownCharacters)
                    if let pageData = imageData{
                        self?.image = UIImage(data: pageData)
                    }
                }
            }
        }).resume()
    }
}

extension UIImage {
    func getImageRatio() -> CGFloat {
        let imageRatio = CGFloat(self.size.width / self.size.height)
        return imageRatio
    }
}

extension FavouriteViewController : FavouriteMangaDelegate{
    func removeOnFavourites(manga: Manga) {
        manga.isFavourite = false
        listOfFavouriteMangas.remove(at: manga.getIndexElement(mangaList: listOfFavouriteMangas))
    }
    
    func addToFavourites(manga: Manga) {
        manga.isFavourite = true
        listOfFavouriteMangas.append(manga)
    }
}

extension String{
    func subStr()->String{
        let start = self.index(self.startIndex, offsetBy: 2)
        let end = self.index(self.endIndex, offsetBy: -1)
        let range = start..<end
        return String(self[range])
    }
}
