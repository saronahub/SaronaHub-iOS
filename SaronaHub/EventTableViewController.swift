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
        if let event = self.event {
            self.initiate(from: event)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initiate(from event: Event) {
        self.eventNameLabel.text = event.name
        if let eventAuthor = event.eventAuthor {
            self.eventHostLabel.text = eventAuthor.FullName
        }
        
        var day, date, hours: String?
        var startTime, endTime: String?
        
        if let startDate = event.startDate {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "he_IL")
            day = formatter.weekdaySymbols[Calendar.current.component(.weekday, from: startDate) - 1]
            date = "\(Calendar.current.component(.day, from: startDate)) ב\(formatter.monthSymbols[Calendar.current.component(.month, from: startDate) - 1])"
            let components = Calendar.current.dateComponents([.hour, .minute], from: startDate)
            if let hour = components.hour, let minute = components.minute {
                startTime = "\(hour < 10 ? "0\(hour)" : "\(hour)"):\(minute < 10 ? "0\(minute)" : "\(minute)")"
            }
        }
        if let endDate = event.endDate {
            let components = Calendar.current.dateComponents([.hour, .minute], from: endDate)
            if let hour = components.hour, let minute = components.minute {
                endTime = "\(hour < 10 ? "0\(hour)" : "\(hour)"):\(minute < 10 ? "0\(minute)" : "\(minute)")"
            }
        }
        
        if let startTime = startTime, let endTime = endTime {
            hours = "\(startTime) - \(endTime)"
        } else if let startTime = startTime {
            hours = startTime
        } else if let endTime = endTime {
            hours = endTime
        }
        
        var dateText: String = ""
        if let day = day {
            dateText += "\(day)"
        }
        if let hours = hours {
            dateText += " \(hours)"
        }
        if let date = date {
            dateText += ", \(date)"
        }
        self.eventDateLabel.text = dateText
        self.eventDescriptionTextView.text = event.description
        self.eventImageView.image = self.image
    }
}
