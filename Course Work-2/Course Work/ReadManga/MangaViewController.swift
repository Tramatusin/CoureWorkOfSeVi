//
//  MangaViewController.swift
//  Course Work
//
//  Created by Виктор Поволоцкий on 10.05.2021.
//

import UIKit

class MangaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentManga?.chapters.count ?? 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chapterCell", for: indexPath) as! ChapterOfMangaTableViewCell
        cell.currentIndex = indexPath.row
        cell.chapOfManga = currentManga
        cell.initCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "readVC") as! ReadViewController
        vc.currentManga = currentManga
        vc.chapter = currentManga?.chapters[indexPath.row].1
        vc.volume = currentManga?.chapters[indexPath.row].0
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        tableViewOfChapters.dataSource = self
        tableViewOfChapters.delegate = self
        textViewOfMangaDescription.text = currentManga?.description
        nameOfTitle.text = currentManga?.name
        if let data = currentManga?.cover{
        imageOfMangaTitle.image = UIImage(data: data)
        }
    }
    
    var currentManga: Manga?
    var favMangaDelegate: FavouriteMangaDelegate?
    
    @IBOutlet weak var imageOfMangaTitle: UIImageView!
    @IBOutlet weak var textViewOfMangaDescription: UITextView!
    @IBOutlet weak var nameOfTitle: UILabel!
    @IBOutlet weak var viewForItems: UIView!
    @IBOutlet weak var tableViewOfChapters: UITableView!
    @IBOutlet weak var favouriteButton: UIButton!
    
    
    @IBAction func addToFavouriteButton(_ sender: Any) {
        if let manga = currentManga, manga.isFavourite == false {
            favouriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            favouriteButton.tintColor = .systemYellow
            favMangaDelegate?.addToFavourites(manga: manga)
        }else if let manga = currentManga, manga.isFavourite == true{
            favMangaDelegate?.removeOnFavourites(manga: manga)
            favouriteButton.setImage(UIImage(systemName: "star"), for: .normal)
            favouriteButton.tintColor = .systemYellow
        }
    }
    
    func initData(){
        if let manga = currentManga,manga.isFavourite == true{
            favouriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            favouriteButton.tintColor = .systemYellow
        }
        favouriteButton.layer.cornerRadius = 10
        viewForItems.layer.cornerRadius = 10
        imageOfMangaTitle.layer.cornerRadius = 10
        nameOfTitle.clipsToBounds = true
        nameOfTitle.layer.cornerRadius = 10
    }
}
