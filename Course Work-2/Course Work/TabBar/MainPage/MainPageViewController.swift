//
//  MainPageViewController.swift
//  Course Work
//
//  Created by Виктор Поволоцкий on 10.04.2021.
//

import UIKit

class MainPageViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var lastSeeCollectionView: UICollectionView!
    @IBOutlet weak var recomendationsCollectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == lastSeeCollectionView{
            return 10
        }
        else{
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == lastSeeCollectionView{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MangaCollectionViewCell
            cell.cellImageView.image = UIImage(named: "signIn.jpg")
            cell.cellImageView.contentMode =  UIView.ContentMode.scaleAspectFill
            cell.layer.cornerRadius = 10
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recomendCell", for: indexPath) as! RecomendMangaCollectionViewCell
            cell.logoMangaImageView.image = UIImage(named: "signIn2.jpg")
            cell.logoMangaImageView.contentMode =  UIView.ContentMode.scaleAspectFill
            cell.layer.cornerRadius = 10
            return cell
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        buttonOfProfile.contentMode = .scaleAspectFill
        buttonOfProfile.imageView?.layer.cornerRadius = 20
        lastSeeCollectionView.layer.cornerRadius = 10
        lastSeeCollectionView.backgroundColor = UIColor(named: "ColViewColor")
        recomendationsCollectionView.layer.cornerRadius=10
        recomendationsCollectionView.backgroundColor = UIColor(named: "ColViewColor")
        lastSeeCollectionView.dataSource = self
        recomendationsCollectionView.dataSource = self
        searchBarOutlet.layer.borderWidth=1
        searchBarOutlet.layer.borderColor = UIColor(named: "backgroundButton")?.cgColor
        if let textfield = searchBarOutlet.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor(named: "backgroundButton")
            textfield.layer.borderColor=UIColor.black.cgColor
            textfield.layer.borderWidth = 0.5
            textfield.layer.cornerRadius = 15
            textfield.borderStyle = .none
            textfield.autoresizingMask =  UIView.AutoresizingMask.flexibleHeight
            textfield.frame = CGRect(x: 20, y: 44, width: 374, height: 100)
        }
    }
    
    
    @IBAction func buttonOfProfileClick(_ sender: Any) {
    }
    
    @IBOutlet weak var buttonOfProfile: UIButton!
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


