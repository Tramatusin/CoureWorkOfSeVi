//
//  MainPageViewController.swift
//  Course Work
//
//  Created by Виктор Поволоцкий on 10.04.2021.
//

import UIKit
import SwiftyJSON

class MainPageViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource , UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var lastSeeCollectionView: UICollectionView!
    @IBOutlet weak var tableViewOfRecomendations: UITableView!
    
    let loadingVC = LoadingViewController()
    var listOfNewMangas: [Manga] = []
    var listOfRecomendation: [Manga] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return listOfNewMangas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MangaCollectionViewCell
            cell.currentManga = listOfNewMangas[indexPath.row]
            cell.initItems()
            cell.layer.cornerRadius = 10
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfRecomendation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recomendCell", for: indexPath) as! RecomendMangaCollectionViewCell
        cell.currentManga = listOfRecomendation[indexPath.row]
        cell.initItems()
        cell.layer.cornerRadius = 10
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "mangaID") as! MangaViewController
        vc.currentManga = listOfRecomendation[indexPath.row]
        present(vc, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        displayContentController(content: loadingVC)
        lastSeeCollectionView.dataSource = self
        lastSeeCollectionView.delegate = self
        tableViewOfRecomendations.dataSource = self
        tableViewOfRecomendations.delegate = self
        initItems()
        DispatchQueue.global().async {
            self.getManga(codeOfManga: "")
        }
        DispatchQueue.global().async {
            self.getOngoings(codeOfManga: "")
        }
    }
    
    
    @IBAction func buttonOfProfileClick(_ sender: Any) {
    }
    
    @IBOutlet weak var buttonOfProfile: UIButton!
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    
    func initItems(){
        buttonOfProfile.contentMode = .scaleAspectFill
        buttonOfProfile.imageView?.layer.cornerRadius = 20
        lastSeeCollectionView.layer.cornerRadius = 10
        lastSeeCollectionView.backgroundColor = UIColor(named: "ColViewColor")
        tableViewOfRecomendations.layer.cornerRadius=10
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
    
    func getManga(codeOfManga: String){
        guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: ["code" : codeOfManga], options: []) else{return}
        guard let url = URL(string: "http://hsemanga.ddns.net:7000/new/")else{return}
        var postReq = URLRequest(url: url)
        postReq.httpMethod = "POST"
        postReq.addValue("application/json", forHTTPHeaderField: "Content-Type")
        postReq.httpBody = jsonData
        
        URLSession.shared.dataTask(with: postReq, completionHandler: {
            [unowned self]
            (data,response,error) in
            
            if error != nil{
                print(error)
            }
            if let dataRes = data{
                
                let swiftyjSON = try? JSON(data: dataRes)
                var tupleOfChapters: [([Int],[Double],[String])] = []
                guard
                    let codes = swiftyjSON?["codes"].arrayValue.map({$0.stringValue}),
                    let volumes = swiftyjSON?["new_manga"].arrayValue.map({$0["chapters"].arrayValue.map({$0["volume"].intValue})}),
                    let names = swiftyjSON?["new_manga"].arrayValue.map({$0["chapters"].arrayValue.map({$0["name"].stringValue})}),
                    let chapters = swiftyjSON?["new_manga"].arrayValue.map({$0["chapters"].arrayValue.map({$0["chapter"].doubleValue})}),
                    let namesOfTitle = swiftyjSON?["new_manga"].arrayValue.map({$0["name"].stringValue}),
                    let discriptions = swiftyjSON?["new_manga"].arrayValue.map({$0["description"].stringValue}),
                    let tags = swiftyjSON?["new_manga"].arrayValue.map({$0["tags"].arrayValue.map({$0.stringValue})}),
                    let covers = swiftyjSON?["new_manga"].arrayValue.map({$0["cover"].stringValue}),
                    let  reting_val = swiftyjSON?["new_manga"].arrayValue.map({$0["rating_value"].stringValue})
                else{
                    print("invalid data json")
                    return
                }
                for i in 0..<volumes.count {
                    tupleOfChapters.append((volumes[i],chapters[i],names[i]))
                }
                for i in 0..<covers.count{
                    let newSubstring = covers[i].subStr()
                    DispatchQueue.main.async {
                        let imageData = Data(base64Encoded: newSubstring, options: .ignoreUnknownCharacters)
                        let manga: Manga = Manga(title: namesOfTitle[i], descript: discriptions[i], tags: tags[i], cover: imageData, rat_val: reting_val[i], code: codes[i], chapters: tupleOfChapters[i])
                        self.listOfNewMangas.append(manga)
                        //self.tableViewOfRecomendations.reloadData()
                        self.lastSeeCollectionView.reloadData()
                    }
                }
                DispatchQueue.main.async {
                    hideContentController(content: loadingVC)
                }
            }
        }).resume()
    }
    
    func getOngoings(codeOfManga: String){
        guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: ["code" : codeOfManga], options: []) else{return}
        guard let url = URL(string: "http://hsemanga.ddns.net:7000/ongoings/")else{return}
        var postReq = URLRequest(url: url)
        postReq.httpMethod = "POST"
        postReq.addValue("application/json", forHTTPHeaderField: "Content-Type")
        postReq.httpBody = jsonData
        
        URLSession.shared.dataTask(with: postReq, completionHandler: {
            [unowned self]
            (data,response,error) in
            
            if error != nil{
                print(error)
            }
            if let dataRes = data{
                
                let swiftyjSON = try? JSON(data: dataRes)
                var tupleOfChapters: [([Int],[Double],[String])] = []
                guard
                    let codes = swiftyjSON?["codes"].arrayValue.map({$0.stringValue}),
                    let volumes = swiftyjSON?["ongoings"].arrayValue.map({$0["chapters"].arrayValue.map({$0["volume"].intValue})}),
                    let names = swiftyjSON?["ongoings"].arrayValue.map({$0["chapters"].arrayValue.map({$0["name"].stringValue})}),
                    let chapters = swiftyjSON?["ongoings"].arrayValue.map({$0["chapters"].arrayValue.map({$0["chapter"].doubleValue})}),
                    let namesOfTitle = swiftyjSON?["ongoings"].arrayValue.map({$0["name"].stringValue}),
                    let discriptions = swiftyjSON?["ongoings"].arrayValue.map({$0["description"].stringValue}),
                    let tags = swiftyjSON?["ongoings"].arrayValue.map({$0["tags"].arrayValue.map({$0.stringValue})}),
                    let covers = swiftyjSON?["ongoings"].arrayValue.map({$0["cover"].stringValue}),
                    let  reting_val = swiftyjSON?["ongoings"].arrayValue.map({$0["rating_value"].stringValue})
                else{
                    print("invalid data json")
                    return
                }
                for i in 0..<volumes.count {
                    tupleOfChapters.append((volumes[i],chapters[i],names[i]))
                }
                for i in 0..<covers.count{
                    let newSubstring = covers[i].subStr()
                    DispatchQueue.main.async {
                        let imageData = Data(base64Encoded: newSubstring, options: .ignoreUnknownCharacters)
                        let manga: Manga = Manga(title: namesOfTitle[i], descript: discriptions[i], tags: tags[i], cover: imageData, rat_val: reting_val[i], code: codes[i], chapters: tupleOfChapters[i])
                        self.listOfRecomendation.append(manga)
                        DispatchQueue.main.async {
                            [weak self] in
                            self?.tableViewOfRecomendations.reloadData()
                        }
                    }
                }
                DispatchQueue.main.async {
                    hideContentController(content: loadingVC)
                }
            }
        }).resume()
    }
    
    func displayContentController(content: UIViewController) {
        tabBarController?.addChild(content)
        tabBarController?.view.addSubview(content.view)
        content.didMove(toParent: self)
    }

    func hideContentController(content: UIViewController) {
        content.willMove(toParent: nil)
        content.view.removeFromSuperview()
        content.removeFromParent()
    }

}


