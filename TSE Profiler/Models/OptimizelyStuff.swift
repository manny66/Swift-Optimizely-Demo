//
//  ManagerFeature.swift
//  TSE Profiler
//
//  Created by Mansoor Omar on 17/5/20.
//  Copyright © 2020 Mansoor Omar. All rights reserved.
//

import Foundation
import Optimizely

class OptimizelyStuff: UIViewController {
    
    // used for creating new tse entries
    // change to "manager" to see feature rollout
    let role = "manager"
    
    // passed in when getting feature flag
    let userId = "bill"
    
    // set delegate to AppDelegate object which will let us use the initalised Optimizely object
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    // rollout feature by passing in key parameter
    func getFeature (key: String) -> Bool {
        
        // get attributes self.role is defined at the beginning of this controller class
        let attributes: [String: Any] = [ "userRole": role ]
        
        // get enabled boolean for feature key
        let enabled = delegate.optimizely.isFeatureEnabled(featureKey: key, userId: userId, attributes: attributes)
        
        print("Feature is enabled? - \(enabled) for userId: \(userId)")
        
        // returns true or flase
        return enabled
    }
    
    // activate experiment by passing in key paramater
    func expActivate (key: String) -> String? {
        
        do {
            let variationKey = try delegate.optimizely.activate(experimentKey: key, userId: userId)
            return variationKey
        } catch {
            print("Error activating experiment: \(error)")
            return nil
        }
    }
    
    // get variation without activating
    func expVariation (key: String) -> String? {
        
        do{
            let variationKey = try delegate.optimizely.getVariationKey(experimentKey: key, userId: userId)
            return variationKey
        } catch {
            print("Error getting variation key: \(error)")
            return nil
        }
    }
    
    // execute track() on the event parameter it requires
    func triggerEvent (event: String) {
        do{
            try delegate.optimizely.track(eventKey: event, userId: userId)
        } catch {
            print("Error trying to trigger event: \(error)")
        }
    }
    
}
