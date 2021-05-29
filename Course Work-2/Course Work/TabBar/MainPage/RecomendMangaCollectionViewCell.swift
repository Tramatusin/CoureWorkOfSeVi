//
//  RecomendMangaCollectionViewCell.swift
//  Course Work
//
//  Created by Виктор Поволоцкий on 11.04.2021.
//

import UIKit

class RecomendMangaCollectionViewCell: UITableViewCell {
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initItems(){
        if let data = currentManga?.cover{
            imageOfManga.image = UIImage(data: data)
        }
        textViewOfDescription.text = currentManga?.description
        labelOfMangaName.text = currentManga?.name
        viewForItems.layer.cornerRadius = 10
    }
    
    @IBOutlet weak var viewForItems: UIView!
    var currentManga: Manga?
    @IBOutlet weak var labelOfMangaName: UILabel!
    @IBOutlet weak var textViewOfDescription: UITextView!
    @IBOutlet weak var imageOfManga: UIImageView!
}
