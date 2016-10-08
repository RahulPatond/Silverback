//
//  ReachabilityController.swift
//  Silverback
//
//  Created by Rahul on 10/8/16.
//  Copyright © 2016 Rahul. All rights reserved.
//

import UIKit

let RemotHostName = "www.google.com"

class ReachabilityController: NSObject {
    static let sharedInstance = ReachabilityController()
    var reachability:Reachability?
    
    override init() {
        super.init()
        initializeReachability()
        
    }
    
    private func initializeReachability() {
        reachability = Reachability(hostName: RemotHostName)
    }
    
    //MARK: - Public methods
    
    func getReachabilityStatus() -> Bool {
        if reachability?.currentReachabilityStatus() == NotReachable {
            return false
        }
        return true
    }
}
