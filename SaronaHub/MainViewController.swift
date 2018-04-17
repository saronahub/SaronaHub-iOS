//
//  MainViewController.swift
//  SaronaHub
//
//  Created by Asaf Baibekov on 17.4.2018.
//  Copyright © 2018 Asaf Baibekov. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navigationController = self.navigationController {
            if let customFont = UIFont(name: "BebasNeue-Regular", size: 22) {
                navigationController.navigationBar.titleTextAttributes = [kCTFontAttributeName: customFont] as [NSAttributedStringKey : Any]
            }
            
        }
//        titleTextAttributes = [NSFontAttributeName: UIFont(name: Font.mediumFontName, size: 20)!]
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
