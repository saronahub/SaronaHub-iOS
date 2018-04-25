//
//  ProfileViewController.swift
//  SaronaHub
//
//  Created by Asaf Baibekov on 22.4.2018.
//  Copyright © 2018 Asaf Baibekov. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var hoursParentView: UIView!
    
    @IBOutlet weak var aboutMeTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let navigationController = self.navigationController {
            navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController.navigationBar.shadowImage = UIImage()
        }
        if let rightBarButtonItem = self.navigationItem.rightBarButtonItem, let font = UIFont(name: "OpenSansHebrew-Bold", size: 14) {
            rightBarButtonItem.setTitleTextAttributes([kCTFontAttributeName as NSAttributedStringKey: font], for: .normal)
            rightBarButtonItem.setTitleTextAttributes([kCTFontAttributeName as NSAttributedStringKey: font], for: .highlighted)
        }
        if let font = UIFont(name: "OpenSansHebrew-Regular", size: 14) {
            self.aboutMeTextView.font = font
        }
    }
    
    override func viewDidLayoutSubviews() {
        let imageViewCornerRadius = min(self.profileImageView.bounds.width, self.profileImageView.bounds.width)/2
        self.profileImageView.layer.masksToBounds = true
        self.profileImageView.layer.cornerRadius = imageViewCornerRadius
        
        self.hoursParentView.layer.masksToBounds = true
        self.hoursParentView.layer.cornerRadius = 10
        self.hoursParentView.layer.borderWidth = 2
        self.hoursParentView.layer.borderColor = UIColor.black.cgColor
        
        self.aboutMeTextView.layer.masksToBounds = true
        self.aboutMeTextView.layer.cornerRadius = 10
        self.aboutMeTextView.layer.borderWidth = 2
        self.aboutMeTextView.layer.borderColor = UIColor.black.cgColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditProfile",
            let navigationController = segue.destination as? UINavigationController,
            let editProfileViewController = navigationController.viewControllers.first as? SetEditProfileViewController {
            editProfileViewController.profileMode = .edit
        }
    }

    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
