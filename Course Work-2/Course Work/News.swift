//
//  News.swift
//  Course Work
//
//  Created by Виктор Поволоцкий on 02.05.2021.
//

import Foundation

class News{
    private let title: String
    private let linkOfImage: String
//    private let shortDiscpr: String
    private let fullNews: String
    private let datePublish: String
    private var image: Data?
    
    init(title: String, linkOfImage: String, fullNewsText: String, datePub: String){
        self.title = title
        self.linkOfImage = linkOfImage
        //self.shortDiscpr = shortDicrip
        self.fullNews = fullNewsText
        self.datePublish = datePub
        }
    
    var getImage:Data?{
        return image
    }
    
    var getTitle:String{
        return title
    }
    
    var getLink: String{
        return linkOfImage
    }

    var getFullNews: String{
        return fullNews
    }
    
    var getDate: String{
        return datePublish
    }
}
