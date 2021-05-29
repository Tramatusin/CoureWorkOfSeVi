//
//  NewsViewController.swift
//  Course Work
//
//  Created by Виктор Поволоцкий on 02.05.2021.
//

import UIKit
import Kanna

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var netReq = NetworkRequest()
    let loadingVC = LoadingViewController()
    var listOfNews: [News] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewTableViewCell
        cell.new = listOfNews[indexPath.row]
        cell.configure()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "newsID") as! LookNewsViewController
        //print(listOfNews?[indexPath.row].getFullNews)
        vc.post = listOfNews[indexPath.row]
        present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewOfNewsOul.delegate = self
        tableViewOfNewsOul.dataSource = self
        tableViewOfNewsOul.separatorStyle = .none
        displayContentController(content: loadingVC)
        DispatchQueue.global().async {
            self.netReq.parseNews(urlStr: "https://readmanga.live/news/allnews") { (listOfNews) in
                DispatchQueue.main.async {
                    self.listOfNews = listOfNews
                    self.tableViewOfNewsOul.reloadData()
                }
            }
        }
        DispatchQueue.global().async {
            self.netReq.parseNews(urlStr: "https://readmanga.live/news/allnews?offset=10") { (listOfNews) in
                DispatchQueue.main.async {
                    self.listOfNews += listOfNews
                    self.tableViewOfNewsOul.reloadData()
                }
            }
            self.netReq.parseNews(urlStr: "https://readmanga.live/news/allnews?offset=20") { (listOfNews) in
                DispatchQueue.main.async {[unowned self] in
                    self.listOfNews += listOfNews
                    self.tableViewOfNewsOul.reloadData()
                    hideContentController(content: loadingVC)
                }
            }
        }
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
    @IBOutlet weak var tableViewOfNewsOul: UITableView!
}
