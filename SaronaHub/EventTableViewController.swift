//
//  EventTableViewController.swift
//  SaronaHub
//
//  Created by Asaf Baibekov on 2.6.2018.
//  Copyright © 2018 Asaf Baibekov. All rights reserved.
//

import UIKit

class EventTableViewController: UITableViewController {

    var event: Event?
    
    var image: UIImage?
    
    @IBOutlet weak var eventImageView: UIImageView!
    
    @IBOutlet weak var eventNameLabel: UILabel!
    
    @IBOutlet weak var eventHostLabel: UILabel!
    
    @IBOutlet weak var eventDateLabel: UILabel!
    
    @IBOutlet weak var eventDescriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
