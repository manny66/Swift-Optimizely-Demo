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
    let userId = "123"
    
    // set delegate to AppDelegate object which will let us use the initalised Optimizely object
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    // rollout feature
    func getFeature () -> Bool {
        
        // get attributes self.role is defined at the beginning of this controller class
        let attributes: [String: Any] = [ "userRole": role ]
        
        // get enabled boolean for feature key
        let enabled = delegate.optimizely.isFeatureEnabled(featureKey: "managerfunctionality", userId: userId, attributes: attributes)
        
        print("Feature is enabled? - \(enabled) for userId: \(userId)")
        
        // returns true or flase
        return enabled
    }
    
    // ab test activation
    func expActivate () -> String? {
        
        do {
            let variationKey = try delegate.optimizely.activate(experimentKey:"adding_colour", userId: userId)
            return variationKey
        } catch {
            print(error)
            return nil
        }
    }
    
    // get variation without activating
    func expVariation () -> String? {
        
        do{
            let variationKey = try delegate.optimizely.getVariationKey(experimentKey: "adding_colour", userId: userId)
            return variationKey
        } catch {
            print(error)
            return nil
        }
    }
    
}
