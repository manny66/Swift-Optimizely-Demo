//
//  TSEList.swift
//  TSE Profiler
//
//  Created by Mansoor Omar on 13/5/20.
//  Copyright © 2020 Mansoor Omar. All rights reserved.
//

import Foundation
import RealmSwift

class TSE: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var role: String = ""
    
    let tasks = List<TSETasks>()
}
