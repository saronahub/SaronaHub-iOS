//
//  RoomEventsViewController.swift
//  SaronaHub
//
//  Created by Asaf Baibekov on 24.4.2018.
//  Copyright © 2018 Asaf Baibekov. All rights reserved.
//

import UIKit
enum RoomType {
    case ventures
    case aquarium
    case openSpace
}

struct Event {
    var id: String
    var name: String
    var description: String
    var roomType: RoomType
    
    var startDate: Date?
    var endDate: Date?
    
    var eventAuthor: User?
    var participantsIds: [String]?
    
    var imageURL: URL?
    
    var minAge: Int?
    var maxAge: Int?
}

struct User {
    var id: String
    var FullName: String
}

class RoomEventsViewController: ViewControllerForPagerTabStrip {

    @IBOutlet weak var tableView: UITableView!
    
    var roomType: RoomType = .openSpace
    
    var events: [Event] = []
    
    @objc func updateData() {
        func fillEvents(_ eventsForRoom: [JSON], roomType: RoomType) -> [Event] {
            var events: [Event] = []
            for event in eventsForRoom {
                let id = event["id"].stringValue
                let name = event["name"].stringValue
                let description = event["description"].stringValue
                let imageURL = event["image"].string ?? ""
                var author: User?
                if let author_id = event["author"]["id"].string,
                    let author_fullname = event["author"]["name"].string {
                    author = User(id: author_id, FullName: author_fullname)
                }
                var start_date: Date?
                var end_date: Date?
                let iso8601formatter = ISO8601DateFormatter()
                iso8601formatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
                if let start_time = event["start_date"].string {
                    start_date = iso8601formatter.date(from: start_time)
                }
                if let end_time = event["end_date"].string {
                    end_date = iso8601formatter.date(from: end_time)
                }
                events.append(
                    Event(id: id,
                          name: name, description: description,
                          roomType: roomType,
                          startDate: start_date, endDate: end_date,
                          eventAuthor: author,
                          participantsIds: nil,
                          imageURL: URL(string: imageURL),
                          minAge: event["minAge"].int, maxAge: event["maxAge"].int)
                )
            }
            return events
        }
        let _ = request(method: .get, "event", with: nil, { (json) in
            self.events.removeAll()
            switch self.roomType {
            case .openSpace:
                if let openSpaceEvents = json["data"]["1"].array {
                    self.events = fillEvents(openSpaceEvents, roomType: .openSpace)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        if let refreshControl = self.tableView.refreshControl {
                            refreshControl.endRefreshing()
                        }
                    }
                }
                break
            case .aquarium:
                if let aquariumEvents = json["data"]["2"].array {
                    self.events = fillEvents(aquariumEvents, roomType: .aquarium)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        if let refreshControl = self.tableView.refreshControl {
                            refreshControl.endRefreshing()
                        }
                    }
                }
                break
            case .ventures:
                if let venturesEvents = json["data"]["3"].array {
                    self.events = fillEvents(venturesEvents, roomType: .ventures)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        if let refreshControl = self.tableView.refreshControl {
                            refreshControl.endRefreshing()
                        }
                    }
                }
                break
            }
        }) { (error) in
            print(error)
            DispatchQueue.main.async {
                let alertController: UIAlertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in
                    if let refreshControl = self.tableView.refreshControl {
                        refreshControl.endRefreshing()
                    }
                }))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateData()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(RoomEventsViewController.updateData), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
}

extension RoomEventsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let storyboard = self.storyboard,
            let eventTableViewController = storyboard.instantiateViewController(withIdentifier: "EventDetails") as? EventTableViewController,
            let navigationController = self.navigationController {
            if let cell = tableView.cellForRow(at: indexPath) as? EventTableViewCell {
                eventTableViewController.event = cell.event
            }
            navigationController.pushViewController(eventTableViewController, animated: true)
        }
    }
}

extension RoomEventsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FloatingCell", for: indexPath) as? EventTableViewCell {
            if traitCollection.forceTouchCapability == .available {
                self.registerForPreviewing(with: self, sourceView: cell)
            }
            let event = self.events[indexPath.row]
            cell.event = event
            return cell
        }
        return UITableViewCell()
    }
}
extension RoomEventsViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard
            let cell = previewingContext.sourceView as? EventTableViewCell,
            let storyboard = self.storyboard,
            let eventTableViewController = storyboard.instantiateViewController(withIdentifier: "EventDetails") as? EventTableViewController
            else {
                return nil
        }
        eventTableViewController.event = cell.event
        return eventTableViewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        if let navigationController = self.navigationController {
            navigationController.pushViewController(viewControllerToCommit, animated: true)
        }
    }
}

class EventTableViewCell: UITableViewCell {
    
    var event: Event? {
        didSet {
            if let event = self.event {
                self.name.text = event.name
                var startTime, endTime: String?
                if let startDate = event.startDate {
                    let formatter = DateFormatter()
                    formatter.locale = Locale(identifier: "he_IL")
                    let monthName = formatter.monthSymbols[Calendar.current.component(.month, from: startDate) - 1]
                    let day: Int = Calendar.current.component(.day, from: startDate)
                    self.dayDate.text = "\(day)"
                    self.monthDate.text = monthName
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
                    self.timeRange.text = "\(startTime) - \(endTime)"
                } else if let startTime = startTime {
                    self.timeRange.text = startTime
                } else if let endTime = endTime {
                    self.timeRange.text = endTime
                }
            }
        }
    }
    
    @IBOutlet weak var cardBackgroundView: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var dayDate: UILabel!
    @IBOutlet weak var monthDate: UILabel!
    @IBOutlet weak var timeRange: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cardBackgroundView.layer.cornerRadius = 5
        self.cardBackgroundView.layer.masksToBounds = true
        self.cardBackgroundView.layer.masksToBounds = false
        self.cardBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.cardBackgroundView.layer.shadowColor = #colorLiteral(red: 0.6588235294, green: 0.6588235294, blue: 0.6588235294, alpha: 1)
        self.cardBackgroundView.layer.shadowOpacity = 0.5
        self.cardBackgroundView.layer.shadowRadius = 5
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        for subview in self.cardBackgroundView.subviews {
            UIView.animate(withDuration: 0.05) {
                subview.alpha = highlighted ? 0.2 : 1
            }
        }
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = layer.shadowOpacity
        animation.toValue = highlighted ? 0.0 : 0.5
        animation.duration = 0.5
        self.cardBackgroundView.layer.add(animation, forKey: animation.keyPath)
        self.cardBackgroundView.layer.shadowOpacity = highlighted ? 0.0 : 0.5
    }
}
