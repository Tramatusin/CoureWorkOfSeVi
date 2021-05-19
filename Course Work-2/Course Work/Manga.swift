//
//  Manga.swift
//  Course Work
//
//  Created by Виктор Поволоцкий on 12.04.2021.
//

import Foundation

class Manga{
    var name: String
    var code: String
    var description: String
    var tags: [String]
    var cover: Data?
    var rating_value: String
    var isFavourite: Bool
    var chapters: [(Int,Double,String)]=[]
    
    
    init(title: String, descript: String, tags: [String], cover: Data?, rat_val: String,
         code: String, chapters: ([Int],[Double],[String])){
        self.name=title
        self.code = code
        self.description = descript
        self.tags = tags
        self.cover = cover
        self.rating_value = rat_val
        self.isFavourite = false
        for i in 0..<chapters.1.count{
            self.chapters.append((chapters.0[i],chapters.1[i],chapters.2[i]))
        }
    }
    
    public func getIndexElement(mangaList: [Manga])->Int{
            return mangaList.firstIndex(where: {element in
                return element.name == self.name
            }) ?? 0
        }
}
