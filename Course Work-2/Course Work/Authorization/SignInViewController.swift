//
//  SignInViewController.swift
//  Course Work
//
//  Created by Виктор Поволоцкий on 08.04.2021.
//

import UIKit

class SignInViewController: UIViewController {
    let netReq = NetworkRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStartView()
    }
    
    @IBOutlet weak var registrButtonOutlet: UIButton!
    @IBOutlet weak var nickFieldOut: UITextField!
    @IBOutlet weak var emailFieldOut: UITextField!
    @IBOutlet weak var passwordFieldOut: UITextField!
    @IBOutlet weak var confirmPasswordFieldOut: UITextField!
    
    func setStartView(){
        passwordFieldOut.clipsToBounds=true
        nickFieldOut.clipsToBounds=true
        emailFieldOut.clipsToBounds=true
        confirmPasswordFieldOut.clipsToBounds=true
        registrButtonOutlet.layer.cornerRadius = 15
        nickFieldOut.layer.cornerRadius = 15
        emailFieldOut.layer.cornerRadius = 15
        passwordFieldOut.layer.cornerRadius = 15
        confirmPasswordFieldOut.layer.cornerRadius = 15
        nickFieldOut.layer.borderWidth = 1
        nickFieldOut.layer.borderColor = UIColor.black.cgColor
        emailFieldOut.layer.borderWidth = 1
        emailFieldOut.layer.borderColor = UIColor.black.cgColor
        passwordFieldOut.layer.borderWidth = 1
        passwordFieldOut.layer.borderColor = UIColor.black.cgColor
        confirmPasswordFieldOut.layer.borderWidth = 1
        confirmPasswordFieldOut.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func registrClickButton(_ sender: Any) {

        NotificationCenter.default.addObserver(self, selector: #selector(gotNotification), name: NSNotification.Name(rawValue: "notificationFromGetAuthData"), object: nil)

        netReq.postUserDataRegister(nickFieldOut.text!, emailFieldOut.text!,
                               passwordFieldOut.text!,
                               confirmPasswordFieldOut.text!,
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
