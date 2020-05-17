//
//  TSEActionItems.swift
//  TSE Profiler
//
//  Created by Mansoor Omar on 13/5/20.
//  Copyright © 2020 Mansoor Omar. All rights reserved.
//

import Foundation
import RealmSwift

// creates TASK objects for a particular TSE
class TSETasks: Object {
    @objc dynamic var created: Date?
    @objc dynamic var title: String? = ""
    @objc dynamic var done: Bool = false
    
    // parent relationship to TSE that creates TASKS obejcts
    var tse = LinkingObjects(fromType: TSE.self, property: "tasks")
}
