//
//  ViewController.swift
//  SaronaHub
//
//  Created by Asaf Baibekov on 13.12.2017.
//  Copyright © 2017 Asaf Baibekov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextView: UITextField!
    @IBOutlet weak var passwordTextView: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let backItem = UIBarButtonItem()
//        backItem.title = ""
//        navigationItem.backBarButtonItem = backItem
        func textFieldDesign(textField: UITextField) {
            textField.layer.masksToBounds = true
            textField.layer.cornerRadius = 10
            textField.layer.borderColor = UIColor.black.cgColor
            textField.layer.borderWidth = 2.5
        }
        textFieldDesign(textField: self.emailTextView)
        textFieldDesign(textField: self.passwordTextView)
        
        self.loginButton.layer.masksToBounds = true
        self.loginButton.layer.cornerRadius = 10
        
        self.facebookLogin.layer.masksToBounds = true
        self.facebookLogin.layer.cornerRadius = 10
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    @IBAction func login(_ sender: Any) {
        if let navigationController = self.navigationController {
            UserDefaults.set(true, forKey: "isLogged")
            navigationController.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func facebookLogin(_ sender: Any) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.backgroundColor = GreenColor
        textField.textColor = UIColor.black
        if let placeholderText = textField.placeholder {
            textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.backgroundColor = UIColor.white
        textField.textColor = UIColor.black
        
        if let placeholderText = textField.placeholder {
            textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedStringKey.foregroundColor: UIColor(red: 199/255, green: 199/255, blue: 205/255, alpha: 1)])
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextView {
            textField.resignFirstResponder()
            self.passwordTextView.becomeFirstResponder()
        } else if textField == self.passwordTextView {
            textField.resignFirstResponder()
            self.loginButton.sendActions(for: .touchUpInside)
        }
        return true
    }
    
}


extension UITabBarController {
    open override func viewDidLoad() {
        if let items = self.tabBar.items {
            for item in items {
                if let selectedImage = item.selectedImage {
                    item.selectedImage = selectedImage.withRenderingMode(.alwaysOriginal)
                }
                if let image = item.image {
                    item.image = image.withRenderingMode(.alwaysOriginal)
                }
            }
        }
    }
}


