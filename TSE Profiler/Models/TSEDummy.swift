//
//  TSEDummy.swift
//  TSE Profiler
//
//  Created by Mansoor Omar on 14/5/20.
//  Copyright © 2020 Mansoor Omar. All rights reserved.
//

import Foundation
import RealmSwift

struct TSEDummy {
    let realm = try! Realm()
    let dummyRole = "tse" // change to "manager" to see rollout

    func populate() {
        // get current number of tses stored
        let currentTses = realm.objects(TSE.self)
        
        // if there are TSE entries already, then no need to populate dummy data
        if currentTses.count < 1 {
            do{
                try self.realm.write{
                    let tseArray = [
                        "Tommy Hoang",
                        "Ali Baker",
                        "Charles Callaghan",
                        "Michal Fasanek",
                        "Tanka Poudel",
                        "Tom Defeo"
                    ]
                    
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
