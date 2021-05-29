//
//  ReadPageTableViewCell.swift
//  Course Work
//
//  Created by Виктор Поволоцкий on 07.05.2021.
//

import UIKit

class ReadPageTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
//        imageView?.contentMode = .scaleToFill
    }
    
    var manga: Manga?
    var data: Data?
    
    func initCell(){
        if let data = data{
            imageOfPage.loadOnData(data: data)
        }
    }
    
    @IBOutlet weak var imageOfPage: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
