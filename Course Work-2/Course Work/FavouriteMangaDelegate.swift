//
//  FavouriteMangaDelegate.swift
//  Course Work
//
//  Created by Виктор Поволоцкий on 11.05.2021.
//

import Foundation

protocol FavouriteMangaDelegate {
    func addToFavourites(manga:Manga)
    
    func removeOnFavourites(manga: Manga)
}
