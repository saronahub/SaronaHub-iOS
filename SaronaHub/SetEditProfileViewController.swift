//
//  SetEditProfileViewController.swift
//  SaronaHub
//
//  Created by Asaf Baibekov on 18.3.2018.
//  Copyright © 2018 Asaf Baibekov. All rights reserved.
//

import UIKit

enum ProfileMode {
    case set, edit
}

struct ProfileData {
    var fullname: String
    var image: UIImage?
    var description: String
}

class SetEditProfileViewController: UIViewController {
    
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var profileParentView: UIView!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    var profileMode: ProfileMode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.profileParentView.layer.masksToBounds = true
        self.profileParentView.layer.borderColor = UIColor.black.cgColor
        self.profileParentView.layer.borderWidth = 3
        self.profileParentView.layer.cornerRadius = min(self.profileParentView.bounds.height, self.profileParentView.bounds.width)/2
        
        
        self.descriptionTextView.layer.masksToBounds = true
        self.descriptionTextView.layer.borderColor = UIColor.black.cgColor
        self.descriptionTextView.layer.borderWidth = 2
        self.descriptionTextView.layer.cornerRadius = 10
        
        
        self.confirmButton.layer.masksToBounds = true
        self.confirmButton.layer.cornerRadius = 10
        
        if self.profileMode == .edit {
            let close = UIBarButtonItem(barButtonSystemItem: .stop, target: nil, action: nil)
            close.tintColor = UIColor.black
            self.navigationItem.leftBarButtonItem = close
            self.confirmButton.setTitle("שמור", for: .normal)
        }
    }
    
    
    @IBAction func confirm(_ sender: Any) {
        if self.profileMode == .set {
            if let navigationController = self.navigationController {
                UserDefaults.set(true, forKey: "isProfileSet")
                navigationController.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension SetEditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.nameTextField {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension SetEditProfileViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let text = textView.text, text == "ספר על עצמך בכמה שורות" {
            textView.text = nil
            textView.backgroundColor = GreenColor
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "ספר על עצמך בכמה שורות"
            textView.backgroundColor = UIColor.white
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == self.descriptionTextView {
            if text == "\n" {
                textView.resignFirstResponder()
                return false
            }
        }
        return true
    }
}


