//
//  MangaCollectionViewCell.swift
//  Course Work
//
//  Created by Виктор Поволоцкий on 10.04.2021.
//

import UIKit

class MangaCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var numberPartOfManga: UILabel!
    var currentManga: Manga?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initItems(){
        if let data = currentManga?.cover{
            cellImageView.image = UIImage(data: data)
        }
        numberPartOfManga.text = currentManga?.name
        cellImageView.contentMode =  UIView.ContentMode.scaleAspectFill
    }
}
