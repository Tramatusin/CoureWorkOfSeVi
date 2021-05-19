//
//  FavouriteMangaCell.swift
//  Course Work
//
//  Created by Виктор Поволоцкий on 13.04.2021.
//

import UIKit

class FavouriteMangaCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        viewOfCell.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getPOV(){
        if let manga = curManga{
            guard let cover = curManga?.cover else {return}
            self.imageOfFavManga.loadOnData(data: cover)
            self.lblOfTitle.text = manga.name
            self.textViewOfDescr.text = manga.description
        }
    }
    
    var curManga: Manga?
    @IBOutlet weak var viewOfCell: UIView!
    @IBOutlet weak var imageOfFavManga: UIImageView!
    @IBOutlet weak var lblOfTitle: UILabel!
    @IBOutlet weak var textViewOfDescr: UITextView!
    
}
