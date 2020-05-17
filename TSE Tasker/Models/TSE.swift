//
//  TSEList.swift
//  TSE Profiler
//
//  Created by Mansoor Omar on 13/5/20.
//  Copyright © 2020 Mansoor Omar. All rights reserved.
//

import Foundation
import RealmSwift

// Used to create TSE objects
class TSE: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var role: String = ""
    
    // relationship to the TASKS under each TSE
    let tasks = List<TSETasks>()
}
