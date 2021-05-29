//
//  LookNewsViewController.swift
//  Course Work
//
//  Created by Виктор Поволоцкий on 02.05.2021.
//

import UIKit

class LookNewsViewController: UIViewController {
    var post: News?

    @IBOutlet weak var titleTextLbl: UILabel!
    @IBOutlet weak var textViewOfNews: UITextView!
    @IBOutlet weak var imageViewOfNews: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLbls()
        self.titleTextLbl.text = post?.getTitle
        self.textViewOfNews.text = post?.getFullNews
        self.textViewOfNews.isEditable = false
        self.imageViewOfNews.load(url: URL(string: post!.getLink)!)
    }
    
    func initLbls(){
        titleTextLbl.layer.cornerRadius = 10
        imageViewOfNews.contentMode = .scaleAspectFill
        imageViewOfNews.center = view.center
        textViewOfNews.layer.cornerRadius = 10
        textViewOfNews.layer.borderWidth = 1
        textViewOfNews.layer.borderColor = UIColor.systemGray4.cgColor
    }
}
