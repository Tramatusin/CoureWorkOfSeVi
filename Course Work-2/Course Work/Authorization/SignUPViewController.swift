//
//  SignUPViewController.swift
//  Course Work
//
//  Created by Виктор Поволоцкий on 08.04.2021.
//

import UIKit

class SignUPViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setStartView()
    }
    
    @IBOutlet weak var loginFieldOutlet: UITextField!
    @IBOutlet weak var passwordFieldOutlet: UITextField!
    @IBOutlet weak var signInButtonOutlet: UIButton!
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var leftImageHero: UIImageView!
    @IBOutlet weak var rightImageHero: UIImageView!
    var netRequest = NetworkRequest()
    
    func setStartView(){
        infoLbl.font = UIFont(name: "Arial Rounded MT Bold", size: 17)
        signInButtonOutlet.layer.cornerRadius = 15
        passwordFieldOutlet.clipsToBounds=true
        loginFieldOutlet.clipsToBounds=true
        passwordFieldOutlet.layer.cornerRadius = 15
        loginFieldOutlet.layer.cornerRadius = 15
        loginFieldOutlet.layer.borderWidth=1
        loginFieldOutlet.layer.borderColor = UIColor.black.cgColor
        passwordFieldOutlet.layer.borderWidth=1
        passwordFieldOutlet.layer.borderColor = UIColor.black.cgColor
        leftImageHero.image = UIImage(named: "signIn2.jpg")
        rightImageHero.image = UIImage(named: "signIn.jpg")
        leftImageHero.layer.cornerRadius = 20
        rightImageHero.layer.cornerRadius = 20
    }
        
    @IBAction func authoriseClickButton(_ sender: Any) {

        NotificationCenter.default.addObserver(self, selector: #selector(gotNotification), name: NSNotification.Name(rawValue: "notificationFromGetAuthData"), object: nil)

        netRequest.postUserDataRegister(loginFieldOutlet.text!, nil,
                                       passwordFieldOutlet.text!,
                                       nil,
                                       self)
    }

    @objc func gotNotification(notification: Notification){
        guard let userInfo = notification.userInfo else {return}
        guard let data = userInfo["status"] as? Bool else {return}

        if data {
            performSegue(withIdentifier: "tabBarVC", sender: nil)
        }

    }
}
