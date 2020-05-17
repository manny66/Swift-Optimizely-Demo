//
//  ManagerFeature.swift
//  TSE Profiler
//
//  Created by Mansoor Omar on 17/5/20.
//  Copyright © 2020 Mansoor Omar. All rights reserved.
//

import Foundation
import Optimizely

class ManagerFeature: UIViewController {
    
    // used for creating new tse entries
       // change to "manager" to see feature rollout
       let role = "manager"
       
       // passed in when getting feature flag
       let userId = "123"
       
    func getFeature () -> Bool {
         
         // set delegate to AppDelegate object
         let delegate = UIApplication.shared.delegate as! AppDelegate
         
         // get attributes self.role is defined at the beginning of this controller class
         let attributes: [String: Any] = [ "userRole": self.role ]
         
         // get enabled boolean for feature key
         let enabled = delegate.optimizely.isFeatureEnabled(featureKey: "managerfunctionality", userId: userId, attributes: attributes)
         
         print("Feature is enabled? - \(enabled) for userId: \(userId)")
         
         // returns true or flase
         return enabled
     }
    
}
