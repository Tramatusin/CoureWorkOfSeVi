//
//  showError.swift
//  Course Work
//
//  Created by Виктор Поволоцкий on 23.04.2021.
//
import UIKit
import Foundation


class ErrorPres{
    public func showError(_ message: String,_ vc: UIViewController){
            DispatchQueue.main.async {
            [weak vc] in
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
                vc?.present(alert, animated: true)
            }
    }
}
