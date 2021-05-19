//
//  OngoingViewController.swift
//  Course Work
//
//  Created by Виктор Поволоцкий on 10.04.2021.
//

import UIKit
import SwiftyJSON

class OngoingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let netQr = NetworkRequest()
    let loadingVC = LoadingViewController()
    var listOfMangas: [Manga] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfMangas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ongCell", for: indexPath) as! OngoingTableViewCell
        cell.curManga = listOfMangas[indexPath.row]
        cell.setData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "mangaID") as! MangaViewController
        //print(listOfNews?[indexPath.row].getFullNews)
        vc.currentManga = listOfMangas[indexPath.row]
        vc.favMangaDelegate = (tabBarController?.viewControllers?[2] as? UINavigationController)?.topViewController as! FavouriteViewController

        present(vc, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayContentController(content: loadingVC)
        DispatchQueue.global().async {
            self.getManga(codeOfManga: "", listOfManga: &self.listOfMangas)
        }
        tableViewOfOngoing.dataSource = self
        tableViewOfOngoing.delegate =
            self
        tableViewOfOngoing.layer.cornerRadius = 10
        tableViewOfOngoing.separatorStyle = .none
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var tableViewOfOngoing: UITableView!
    
    func getManga(codeOfManga: String, listOfManga: inout [Manga]){
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
                        self.listOfMangas.append(manga)
                        DispatchQueue.main.async {
                            [weak self] in
                            self?.tableViewOfOngoing.reloadData()
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
