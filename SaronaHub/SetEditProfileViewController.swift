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
    
    @IBOutlet weak var profileButton: UIButton!
    
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
            let close = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(SetEditProfileViewController.close))
            close.tintColor = UIColor.black
            self.navigationItem.leftBarButtonItem = close
            self.confirmButton.setTitle("שמור", for: .normal)
        }
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
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
    
    @IBAction func addProfileImage(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "מצלמה", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("Camera not available")
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "גלריית תמונות", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "ביטול", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
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

extension SetEditProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.profileButton.setBackgroundImage(image, for: .normal)
        } else if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.profileButton.setBackgroundImage(image, for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension SetEditProfileViewController: UINavigationControllerDelegate {
    
}
