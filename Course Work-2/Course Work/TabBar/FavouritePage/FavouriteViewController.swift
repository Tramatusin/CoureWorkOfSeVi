//
//  FavouriteViewController.swift
//  Course Work
//
//  Created by Виктор Поволоцкий on 10.04.2021.
//

import UIKit

class FavouriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var listOfFavouriteMangas: [Manga] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfFavouriteMangas.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favouriteCell", for: indexPath) as! FavouriteMangaCell
        cell.curManga = listOfFavouriteMangas[indexPath.row]
        cell.getPOV()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "mangaID") as! MangaViewController
        vc.currentManga = listOfFavouriteMangas[indexPath.row]
        vc.favMangaDelegate = self
        present(vc, animated: true, completion: nil)
    }

    @IBOutlet weak var favouriteSearchBar: UISearchBar!
    
    @IBOutlet weak var favouriteTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favouriteTableView.dataSource = self
        favouriteTableView.delegate = self
        // Do any additional setup after loading the view.
        favouriteSearchBar.layer.borderWidth=1
        favouriteTableView.reloadData()
        favouriteSearchBar.layer.borderColor=UIColor(named: "backgroundButton")?.cgColor
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favouriteTableView.reloadData()
    }
    
}
