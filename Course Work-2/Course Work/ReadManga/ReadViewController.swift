//
//  ReadViewController.swift
//  Course Work
//
//  Created by Виктор Поволоцкий on 07.05.2021.
//

import UIKit

class ReadViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var currentManga: Manga?
    var listOfPages: [Data]?
    var chapter: Double?
    var volume: Int?
    let loadingVC = LoadingViewController()
    let netReq = NetworkRequest()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfPages?.count ?? 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "readCell", for: indexPath) as! ReadPageTableViewCell
        guard let listPage = listOfPages else {
            return cell
        }
        //let image = UIImage(data: listPage[indexPath.row])
        cell.data = listPage[indexPath.row]
//        print("изображение \(image?.size.height)")
//        print("imageview \(cell.imageOfPage.frame.size.height)")
//        print("cell \(cell.frame.size.height)")
        cell.initCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let listPage = listOfPages else {return CGFloat(1000)}
        let image = UIImage(data: listPage[indexPath.row])
        guard let imageRatio = image?.getImageRatio() else {return CGFloat(1000)}
        return tableView.frame.width / imageRatio
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        readTableView.dataSource = self
        readTableView.delegate = self
        displayContentController(content: loadingVC)
        readTableView.rowHeight = -1
        initItems()
        DispatchQueue.global().async {
            if let vol = self.volume, let chap = self.chapter{
                self.netReq.getPageOfChapterOfManga(jsonData: self.netReq.buildJsonOfPage(self.currentManga?.code, vol, chap, 1), completition: {
                    [unowned self]
                    (pages) in
                    DispatchQueue.main.async {
                        self.listOfPages = pages
                        self.readTableView.reloadData()
                        hideContentController(content: loadingVC)
                    }
                })
            }
        }
    }
    
    func initItems(){
        lblOfChapter.clipsToBounds = true
        lblOfChapter.layer.cornerRadius = 10
        if let vol = volume, let chap = chapter{
            lblOfChapter.text = "Том \(vol) Глава \(chap)"
        }
        backButtonDissmiss.layer.cornerRadius = 10
    }

    func displayContentController(content: UIViewController) {
        self.addChild(content)
        self.view.addSubview(content.view)
        content.didMove(toParent: self)
    }

    func hideContentController(content: UIViewController) {
        content.willMove(toParent: nil)
        content.view.removeFromSuperview()
        content.removeFromParent()
    }


    @IBOutlet weak var readTableView: UITableView!
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var lblOfChapter: UILabel!
    @IBOutlet weak var backButtonDissmiss: UIButton!
    
}
