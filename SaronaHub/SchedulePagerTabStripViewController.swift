//
//  SchedulePagerTabStripViewController.swift
//  SaronaHub
//
//  Created by Asaf Baibekov on 24.4.2018.
//  Copyright © 2018 Asaf Baibekov. All rights reserved.
//

import UIKit
let PurpleColor = UIColor(red: 158/255, green: 51/255, blue: 154/255, alpha: 1.0)
class SchedulePagerTabStripViewController: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        
        let font = UIFont(name: "OpenSansHebrew-Bold", size: 15)!
        settings.style.buttonBarItemFont = font
        settings.style.buttonBarItemBackgroundColor = #colorLiteral(red: 0.5921568627, green: 0.8392156863, blue: 0.8549019608, alpha: 1)
        settings.style.selectedBarHeight = 2
        settings.style.buttonBarMinimumLineSpacing = 0
        changeCurrentIndexProgressive = { (oldCell, newCell, progressPercentage, changeCurrentIndex, animated) -> Void in
            guard changeCurrentIndex == true else { return }
            if let oldCell = oldCell {
                oldCell.label.textColor = .white
            }
            if let newCell = newCell {
                newCell.label.textColor = .black
            }
        }
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewControllersForPagerTabStrip(_ pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        var viewControllersForPagerTabStrip: [ViewControllerForPagerTabStrip] = []
        if let storyboard = self.storyboard {
            if let venturesRoomViewController = storyboard.instantiateViewController(withIdentifier: "RoomEvents") as? RoomEventsViewController {
                venturesRoomViewController.itemInfo.title = "חדר המיזמים"
                venturesRoomViewController.roomType = .ventures
                viewControllersForPagerTabStrip.append(venturesRoomViewController)
            }
            if let aquariumViewController = storyboard.instantiateViewController(withIdentifier: "RoomEvents") as? RoomEventsViewController {
                aquariumViewController.itemInfo.title = "האקווריום"
                aquariumViewController.roomType = .aquarium
                viewControllersForPagerTabStrip.append(aquariumViewController)
            }
            if let openSpaceViewController = storyboard.instantiateViewController(withIdentifier: "RoomEvents") as? RoomEventsViewController {
                openSpaceViewController.itemInfo.title = "המרחב הפתוח"
                openSpaceViewController.roomType = .openSpace
                viewControllersForPagerTabStrip.append(openSpaceViewController)
            }
        }
        pagerTabStripController.moveToViewControllerAtIndex(viewControllersForPagerTabStrip.count, animated: false)
        return viewControllersForPagerTabStrip
    }
}

class ButtonWithImage: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        if let imageView = imageView {
            self.contentHorizontalAlignment = .right
            let space: CGFloat = 16
            imageEdgeInsets = UIEdgeInsets(top: 0, left: (bounds.width - imageView.bounds.width - space), bottom: 0, right: space)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: imageView.bounds.width + space*2)
        }
    }
}








