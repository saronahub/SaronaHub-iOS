//
//  RegisterViewController.swift
//  SaronaHub
//
//  Created by Asaf Baibekov on 14.1.2018.
//  Copyright © 2018 Asaf Baibekov. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let placeholders = ["הקלד שם משתמש", "הקלד דואר אלקטרוני", "הקלד סיסמא", "אימות סיסמא", "מספר פלאפון"]
    
    var activeTextField: UITextField?
    var endEditTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        
    }
    
    @objc func registerButtonClicked(sender: UIButton) {
        var username: String?
        var mail: String?
        var password: String?
        var confirmPassword: String?
        var phoneNumber: String?
        
        func textFromTextFieldCell(row: Int) -> String? {
            guard let acell = self.tableView.cellForRow(at: IndexPath(row: row, section: 0)),
                  let cell = acell as? TextFieldCell,
                  let text = cell.textField.text else { return nil }
            return text
        }
        
        username = textFromTextFieldCell(row: 0)
        mail = textFromTextFieldCell(row: 1)
        password = textFromTextFieldCell(row: 2)
        confirmPassword = textFromTextFieldCell(row: 3)
        phoneNumber = textFromTextFieldCell(row: 4)
        
        self.navigationController!.popViewController(animated: true)
    }
    
    @objc func loginButtonClicked(sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    

    @objc func keyboardWillHide(note: NSNotification) {
        if let endEditTextField = self.endEditTextField,
            let textFieldSuperView = endEditTextField.superview,
            let textFieldSuperViewSuperView = textFieldSuperView.superview,
            let textFieldCell = textFieldSuperViewSuperView as? TextFieldCell,
            let indexPath = self.tableView.indexPath(for: textFieldCell) {
            self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
            self.endEditTextField = nil
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

extension RegisterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row != self.placeholders.count {
            return (self.view.bounds.height / (1.75 * 7.5)) + 16
        }
        return UITableViewAutomaticDimension
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.placeholders.count + 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == self.placeholders.count {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as? ButtonCell {
                cell.registerButton.layer.masksToBounds = true
                cell.registerButton.layer.cornerRadius = 10
                cell.registerButton.addTarget(self, action: #selector(RegisterViewController.registerButtonClicked(sender:)), for: .touchUpInside)
                cell.loginButton.addTarget(self, action: #selector(RegisterViewController.loginButtonClicked(sender:)), for: .touchUpInside)
                return cell
            }
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as? TextFieldCell {
            switch indexPath.row {
            case 0:
                cell.textField.keyboardType = .default
                break
            case 1:
                cell.textField.keyboardType = .emailAddress
                break
            case 2:
                cell.textField.keyboardType = .default
                cell.textField.isSecureTextEntry = true
                break
            case 3:
                cell.textField.keyboardType = .default
                cell.textField.isSecureTextEntry = true
                break
            case 4:
                cell.textField.keyboardType = .phonePad
                break
            default:
                break
            }
            cell.textField.delegate = self
            cell.textField.layer.masksToBounds = true
            cell.textField.layer.cornerRadius = 10
            cell.textField.layer.borderColor = UIColor.black.cgColor
            cell.textField.layer.borderWidth = 2.5
            
            cell.textField.placeholder = self.placeholders[indexPath.row]
            return cell
        }
        
        return UITableViewCell()
    }
}

extension RegisterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.activeTextField = textField
        self.endEditTextField = nil
        
        let pointInTable = textField.convert(textField.frame.origin, to: self.tableView)
        let contentOffset = self.tableView.contentOffset
        var contentoff = contentOffset
        contentoff.y = pointInTable.y - textField.frame.size.height
        self.tableView.setContentOffset(contentoff, animated: true)
        
        textField.backgroundColor = GreenColor
        textField.textColor = UIColor.white
        if let placeholderText = textField.placeholder {
            textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.activeTextField = nil
        self.endEditTextField = textField
        
        textField.backgroundColor = UIColor.white
        textField.textColor = UIColor.black
        
        if let placeholderText = textField.placeholder {
            textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedStringKey.foregroundColor: UIColor(red: 199/255, green: 199/255, blue: 205/255, alpha: 1)])
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let returnedTextFieldCell = textField.superview!.superview as? TextFieldCell,
            var indexPath = self.tableView.indexPath(for: returnedTextFieldCell) {
            indexPath.row += 1
            if let nextCell = self.tableView.cellForRow(at: indexPath),
                let nextTextFieldCell = nextCell as? TextFieldCell{
                nextTextFieldCell.textField.becomeFirstResponder()
            }
        }
        return true
    }
}


class TextFieldCell: UITableViewCell {
    @IBOutlet weak var textField: UITextField!
}

class ButtonCell: UITableViewCell {
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
}






class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var forgotPasswordTextView: UITextField!
    
    @IBOutlet weak var restorePasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.forgotPasswordTextView.layer.masksToBounds = true
        self.forgotPasswordTextView.layer.cornerRadius = 10
        self.forgotPasswordTextView.layer.borderColor = UIColor.black.cgColor
        self.forgotPasswordTextView.layer.borderWidth = 2.5
        
        self.restorePasswordButton.layer.masksToBounds = true
        self.restorePasswordButton.layer.cornerRadius = 10
    }
    
    @IBAction func restore(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension ForgotPasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.backgroundColor = GreenColor
        textField.textColor = UIColor.white
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
        textField.resignFirstResponder()
        
        return true
    }
}








