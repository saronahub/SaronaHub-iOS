//
//  InitialViewController.swift
//  SaronaHub
//
//  Created by Asaf Baibekov on 12.1.2018.
//  Copyright © 2018 Asaf Baibekov. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults.bool(forKey: "isLogged") {
            if UserDefaults.bool(forKey: "isProfileSet") {
                self.performSegue(withIdentifier: "LoggedIn", sender: self)
            } else {
                self.performSegue(withIdentifier: "SetProfile", sender: self)
            }
            
        } else {
            self.performSegue(withIdentifier: "UserNeedToLogin", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoggedIn" || segue.identifier == "UserNeedToLogin" {
            segue.destination.transitioningDelegate = self
        }
        if segue.identifier == "SetProfile",
            let navigationController = segue.destination as? UINavigationController,
            let setProfileViewController = navigationController.viewControllers.first as? SetEditProfileViewController {
            setProfileViewController.profileMode = .set
            segue.destination.transitioningDelegate = self
        }
    }
}

extension InitialViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentViewControllerFadeTransition()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissViewControllerFadeTransition()
    }
}
