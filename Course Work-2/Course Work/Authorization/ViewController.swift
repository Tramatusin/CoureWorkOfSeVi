//
//  ViewController.swift
//  Course Work
//
//  Created by Виктор Поволоцкий on 07.04.2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setStartView()
    }
    
    var netreq = NetworkRequest()
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var helloImageView: UIImageView!
    
    @IBOutlet weak var signUpButtonOutlet: UIButton!
    @IBOutlet weak var authorizeButtonOutlet: UIButton!
    
    
    @IBAction func authrizeClick(_ sender: Any) {
        performSegue(withIdentifier: "signUpVC", sender: nil)
    }
    
    @IBAction func signUpClick(_ sender: Any) {
        performSegue(withIdentifier: "signInVC", sender: nil)
    }
    
    func setStartView(){
        helloImageView.image = UIImage(named: "Authorize.jpg")
        signUpButtonOutlet.layer.cornerRadius = 10
        authorizeButtonOutlet.layer.cornerRadius = 10
//        signUpButtonOutlet.backgroundColor = UIColor(named: "backgroundButton")
//        authorizeButtonOutlet.backgroundColor = UIColor(named: "backgroundButton")
        helloLabel.font = UIFont(name: "Arial Rounded MT Bold", size: 17)
        helloImageView.layer.cornerRadius = 20
        helloImageView.contentMode =  UIView.ContentMode.scaleAspectFill
        helloImageView.clipsToBounds = true
        helloImageView.center = view.center
    }
}

