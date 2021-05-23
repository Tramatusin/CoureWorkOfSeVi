//
//  OngoingViewController.swift
//  Course Work
//
//  Created by Виктор Поволоцкий on 10.04.2021.
//

import UIKit
import SwiftyJSON
import Foundation

enum  PageType{
    case mangas
    case manhvas
    case manhuyas
}

class OngoingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let batchCount = 10
    let netQr = NetworkRequest()
    let loadingVC = LoadingViewController()
    var pageType: PageType = .mangas
    var listOfMangas: [Manga] = []
    var listOfManhva: [Manga] = []
    var listOfManhuyas: [Manga] = []
    var firstClickManhva = false
    var firstClickManhuya = false
    
    
    
    @IBOutlet weak var ButtonOfMangasOut: UIButton!
    @IBOutlet weak var buttonOfManhvasOut: UIButton!
    @IBOutlet weak var buttonOfManhyas: UIButton!
    
    
    @IBAction func clickOnMangas(_ sender: Any) {
        pageType = .mangas
        ButtonOfMangasOut.setTitleColor(UIColor.black, for: .normal)
        ButtonOfMangasOut.titleLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 28)
        buttonOfManhvasOut.titleLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 18)
        buttonOfManhyas.titleLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 18)
        tableViewOfOngoing.reloadData()
    }
    
    
    @IBAction func clickOnManhvas(_ sender: Any) {
        pageType = .manhvas
        if firstClickManhva == false{
            displayContentController(content: loadingVC)
            self.getManga(batchCount: 1, urlStr: "http://hsemanga.ddns.net:7000/catalogues/manhva/"){
                (mangas) in
                DispatchQueue.main.async {
                    self.listOfManhva += mangas
                    self.tableViewOfOngoing.reloadData()
                }
            }
            for i in 2...batchCount{
                DispatchQueue.global().async {
                    self.getManga(batchCount: i, urlStr: "http://hsemanga.ddns.net:7000/catalogues/manhva/"){
                        (mangas) in
                        DispatchQueue.main.async {
                            self.listOfManhva += mangas
                            self.tableViewOfOngoing.reloadData()
                        }
                    }
                }
            }
            firstClickManhva = true
        }
        buttonOfManhvasOut.setTitleColor(UIColor.black, for: .normal)
        buttonOfManhvasOut.titleLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 28)
        ButtonOfMangasOut.titleLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 18)
        buttonOfManhyas.titleLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 18)
        tableViewOfOngoing.reloadData()
    }
    
    
    @IBAction func clickOnManhyas(_ sender: Any) {
        pageType = .manhuyas
        if firstClickManhuya == false{
            displayContentController(content: loadingVC)
            self.getManga(batchCount: 1, urlStr: "http://hsemanga.ddns.net:7000/catalogues/manhya/"){
                (mangas) in
                DispatchQueue.main.async {
                    self.listOfManhuyas += mangas
                    self.tableViewOfOngoing.reloadData()
                }
            }
            for i in 2...batchCount{
                DispatchQueue.global().async {
                    self.getManga(batchCount: i, urlStr: "http://hsemanga.ddns.net:7000/catalogues/manhya/"){
                        (mangas) in
                        DispatchQueue.main.async {
                            self.listOfManhuyas += mangas
                            self.tableViewOfOngoing.reloadData()
                        }
                    }
                }
            }
            firstClickManhuya = true
        }
        buttonOfManhyas.setTitleColor(UIColor.black, for: .normal)
        buttonOfManhyas.titleLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 28)
        ButtonOfMangasOut.titleLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 18)
        buttonOfManhvasOut.titleLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 18)
        tableViewOfOngoing.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pageType == .mangas{
            return listOfMangas.count
        }else if pageType == .manhvas{
            return listOfManhva.count
        }else{
            return listOfManhuyas.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ongCell", for: indexPath) as! OngoingTableViewCell
        if pageType == .mangas{
            cell.curManga = listOfMangas[indexPath.row]
        }else if pageType == .manhvas{
            cell.curManga = listOfManhva[indexPath.row]
        }else{
            cell.curManga = listOfManhuyas[indexPath.row]
        }
        cell.setData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "mangaID") as! MangaViewController
        if pageType == .mangas{
            vc.currentManga = listOfMangas[indexPath.row]
        }else if pageType == .manhvas{
            vc.currentManga = listOfManhva[indexPath.row]
        }else{
            vc.currentManga = listOfManhuyas[indexPath.row]
        }
        vc.favMangaDelegate = (tabBarController?.viewControllers?[2] as? UINavigationController)?.topViewController as! FavouriteViewController
        present(vc, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayContentController(content: loadingVC)
        initController()
        self.getManga(batchCount: 1, urlStr: "http://hsemanga.ddns.net:7000/catalogues/manga/"){
            (mangas) in
            DispatchQueue.main.async {
                self.listOfMangas += mangas
                self.tableViewOfOngoing.reloadData()
            }
        }
        for i in 2...batchCount{
            DispatchQueue.global().async {
                self.getManga(batchCount: i, urlStr: "http://hsemanga.ddns.net:7000/catalogues/manga/"){
                    (mangas) in
                    DispatchQueue.main.async {
                        self.listOfMangas += mangas
                        self.tableViewOfOngoing.reloadData()
                    }
                }
            }
        }
        tableViewOfOngoing.dataSource = self
        tableViewOfOngoing.delegate =
            self
        // Do any additional setup after loading the view.
    }
    
    func initController(){
        ButtonOfMangasOut.setTitleColor(UIColor.black, for: .normal)
        ButtonOfMangasOut.titleLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 28)
        tableViewOfOngoing.layer.cornerRadius = 10
        tableViewOfOngoing.separatorStyle = .none
    }

    @IBOutlet weak var tableViewOfOngoing: UITableView!
    
    func getManga(batchCount: Int, urlStr: String, completition: @escaping ([Manga])->()){
        guard let jsonData: Data = try? JSONSerialization.data(withJSONObject: ["batch_num" : batchCount], options: []) else{return}
        guard let url = URL(string: urlStr)else{return}
        var listManga: [Manga] = []
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
                    let volumes = swiftyjSON?["mangas"].arrayValue.map({$0["chapters"].arrayValue.map({$0["volume"].intValue})}),
                    let names = swiftyjSON?["mangas"].arrayValue.map({$0["chapters"].arrayValue.map({$0["name"].stringValue})}),
                    let chapters = swiftyjSON?["mangas"].arrayValue.map({$0["chapters"].arrayValue.map({$0["chapter"].doubleValue})}),
                    let namesOfTitle = swiftyjSON?["mangas"].arrayValue.map({$0["name"].stringValue}),
                    let discriptions = swiftyjSON?["mangas"].arrayValue.map({$0["description"].stringValue}),
                    let tags = swiftyjSON?["mangas"].arrayValue.map({$0["tags"].arrayValue.map({$0.stringValue})}),
                    let covers = swiftyjSON?["mangas"].arrayValue.map({$0["cover"].stringValue}),
                    let  reting_val = swiftyjSON?["mangas"].arrayValue.map({$0["rating_value"].stringValue})
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
                        listManga.append(manga)
                        DispatchQueue.main.async {
                            [weak self] in
                            self?.tableViewOfOngoing.reloadData()
                        }
                    }
                }
                DispatchQueue.main.async {
                    completition(listManga)
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
