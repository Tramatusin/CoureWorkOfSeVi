//
//  ChapterOfMangaTableViewCell.swift
//  Course Work
//
//  Created by Виктор Поволоцкий on 10.05.2021.
//

import UIKit

class ChapterOfMangaTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        viewOfChap.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initCell(){
        if  let manga = chapOfManga, let index = currentIndex{
            let aNumber = modf(manga.chapters[index].1)
//        aNumber.0 // 3.0
//        aNumber.1 // 0.12345
            if aNumber.1 == 0{
                if let manga = chapOfManga, let index = currentIndex, manga.chapters[manga.chapters.count-1].1 == 0{
                    lablelOfChap.text = "Том \(Int(manga.chapters[index].0)) Глава \(Int(manga.chapters[index].1)) \(manga.chapters[index].2)"
                }else if let manga = chapOfManga, let index = currentIndex{
                    if index == manga.chapters.count{
                        lablelOfChap.text = "Том \(manga.chapters[index-1].0) Глава \(manga.chapters[index-1].1) \(manga.chapters[index-1].2)"
                    }else{
                        lablelOfChap.text = "Том \(manga.chapters[index].0) Глава \(manga.chapters[index].1) \(manga.chapters[index].2)"
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var viewOfChap: UIView!
    @IBOutlet weak var lablelOfChap: UILabel!
    var chapOfManga: Manga?
    var currentIndex: Int?
}
