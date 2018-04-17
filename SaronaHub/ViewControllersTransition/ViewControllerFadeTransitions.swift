//
//  CustomPresentAnimationController.swift
//  CustomTransitions
//
//  Created by Asaf Baibekov on 13.12.2017.
//  Copyright © 2018 Asaf Baibekov. All rights reserved.
//

import UIKit

class PresentViewControllerFadeTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard  let toViewController = transitionContext.viewController(forKey: .to) else { return }
        let containerView = transitionContext.containerView
        toViewController.view.frame = containerView.bounds
        containerView.insertSubview(toViewController.view, at: 0)
        
        let duration = self.transitionDuration(using: transitionContext)
        
        toViewController.view.alpha = 0
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .curveEaseIn, animations: {
            toViewController.view.alpha = 1
        }, completion: { finished in
            transitionContext.completeTransition(true)
        })
    }
}

class DismissViewControllerFadeTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let containerView = transitionContext.containerView
        containerView.addSubview(toViewController.view)
        
        let duration = self.transitionDuration(using: transitionContext)
        
        toViewController.view.alpha = 0
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .curveEaseIn, animations: {
            toViewController.view.alpha = 1
        }, completion: { finished in
            transitionContext.completeTransition(true)
        })
    }
}

