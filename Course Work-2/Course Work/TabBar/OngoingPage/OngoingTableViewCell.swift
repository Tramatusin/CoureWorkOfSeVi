//OngoingTableViewCell
//  OngoingTableViewCell.swift
//  Course Work
//
//  Created by Виктор Поволоцкий on 22.04.2021.
//

import UIKit

class OngoingTableViewCell: UITableViewCell {

    var curManga: Manga?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewOfOngoingManga.layer.cornerRadius = 10
        imageOfTitle.contentMode = .scaleAspectFill
    }

    @IBOutlet weak var viewOfOngoingManga: UIView!
    @IBOutlet weak var titleOfManga: UILabel!
    @IBOutlet weak var fieldOfDescription: UITextView!
    @IBOutlet weak var lblOfRait: UILabel!
    @IBOutlet weak var imageOfTitle: UIImageView!
    
    func setData(){
        self.fieldOfDescription.text = curManga?.description
        self.lblOfRait.text = "⭐️"+curManga!.rating_value
        self.titleOfManga.text = curManga?.name
        if let data = curManga?.cover{
            self.imageOfTitle.image = UIImage(data: data)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
