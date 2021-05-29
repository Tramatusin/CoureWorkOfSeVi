//
//  NewTableViewCell.swift
//  Course Work
//
//  Created by Виктор Поволоцкий on 02.05.2021.
//

import UIKit

class NewTableViewCell: UITableViewCell {
    var new: News?
    
    override func awakeFromNib() {
        imageOfNew.contentMode = .scaleAspectFill
        viewOfContentCell.layer.cornerRadius = 10
        imageOfNew.layer.cornerRadius = 10
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBOutlet weak var viewOfContentCell: UIView!
    @IBOutlet weak var imageOfNew: UIImageView!
    @IBOutlet weak var shortDiscrLbl: UILabel!
    @IBOutlet weak var dateOfPublishLbl: UILabel!
    
    func configure(){
        imageOfNew.load(url: URL(string: new!.getLink)!)
        dateOfPublishLbl.text = new?.getDate
        shortDiscrLbl.text = new?.getTitle
    }
}
