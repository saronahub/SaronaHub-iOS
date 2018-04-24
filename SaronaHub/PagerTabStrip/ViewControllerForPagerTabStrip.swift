//
//  ViewControllerForPagerTabStrip.swift
//  SugarRun
//
//  Created by Asaf Baibekov on 9.8.2016.
//  Copyright © 2016 AasfB. All rights reserved.
//

import UIKit

class ViewControllerForPagerTabStrip: UIViewController {
    
    var buttonBarPagerTabStripViewController: ButtonBarPagerTabStripViewController?
    
    @IBInspectable var titleIndicatorInfo: String? {
        didSet {
            self.itemInfo.title = titleIndicatorInfo!
        }
    }
    
    var itemInfo: IndicatorInfo = IndicatorInfo(title: "")
    
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ViewControllerForPagerTabStrip: IndicatorInfoProvider {
    func indicatorInfoForPagerTabStrip(_ pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        if let vc = pagerTabStripController as? ButtonBarPagerTabStripViewController {
            self.buttonBarPagerTabStripViewController = vc
        }
        return itemInfo
    }
}
