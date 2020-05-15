//
//  TSEDummy.swift
//  TSE Profiler
//
//  Created by Mansoor Omar on 14/5/20.
//  Copyright © 2020 Mansoor Omar. All rights reserved.
//

import Foundation
import RealmSwift

// Creates TSE entries by default if none exist
struct TSEDummy {
    let realm = try! Realm()
    let dummyRole = "tse" // change to "manager" to see rollout

// this function is called from TSEListViewController
    func populate() {
        // get current number of tses stored
        let currentTses = realm.objects(TSE.self)
        
        // if there are TSE entries already, then no need to populate dummy data
        if currentTses.count < 1 {
            do{
                // being write process into realm DB
                try self.realm.write{
                    let tseArray = [
                        "Tommy Hoang",
                        "Ali Baker",
                        "Charles Callaghan",
                        "Michal Fasanek",
                        "Tanka Poudel",
                        "Tom Defeo"
                    ]
                    // loop through array and create TSE entries for each
                    for engineer in tseArray {
                        let tse = TSE()
                        tse.name = engineer
                        tse.role = dummyRole
                        self.realm.add(tse)
                    }
                }
            } catch {
                print("unable to add new tse: \(error)")
            }
        }
    }
    
    
}
