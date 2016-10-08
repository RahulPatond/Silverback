//
//  ActivityIndicatorController.swift
//  WebService
//
//  Created by Rahul on 10/7/16.
//  Copyright © 2016 Rahul. All rights reserved.
//

import UIKit

class ActivityIndicatorController: NSObject {

    static let sharedInstance = ActivityIndicatorController()
    var activityIndicator : UIActivityIndicatorView?
    
    func showActivityIndicator() {
        
        activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        activityIndicator?.alpha = 1.0
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        activityIndicator?.center = CGPoint(x: (appDelegate.window?.rootViewController?.view.frame.maxX)!/2, y: (appDelegate.window?.rootViewController?.view.frame.maxY)!/2)
        DispatchQueue.main.async {
            appDelegate.window?.rootViewController?.view.addSubview(self.activityIndicator!)
            self.activityIndicator?.startAnimating()
        }
        
    }
    
    func removeActivityController() {
        DispatchQueue.main.async {
            self.activityIndicator?.stopAnimating()
            self.activityIndicator?.removeFromSuperview()
        }
    }

    
}
