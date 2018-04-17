//
//  VisitsHistoryViewController.swift
//  SaronaHub
//
//  Created by Asaf Baibekov on 31.1.2018.
//  Copyright © 2018 Asaf Baibekov. All rights reserved.
//

import UIKit

class VisitsHistoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.tableView.rowHeight = UITableViewAutomaticDimension
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

extension VisitsHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "VisitHistoryCell", for: indexPath) as? VisitsHistoryTableViewCell {
            cell.beginTimeLabel.text = "16:30"
            cell.endTimeLabel.text = "20:00"
            cell.dateTimeLabel.text = "22/10/2017"
            cell.dayInWeekLabel.text = "יום ראשון"
            return cell
        }
        return UITableViewCell()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
}

extension VisitsHistoryViewController: UITableViewDelegate {
    
}

class VisitsHistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var beginTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var dayInWeekLabel: UILabel!
//    var visitHistory: Calendar!
    
}


