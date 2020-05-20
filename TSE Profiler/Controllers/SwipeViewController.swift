//
//  SwipeViewController.swift
//  TSE Profiler
//
//  Created by Mansoor Omar on 17/5/20.
//  Copyright © 2020 Mansoor Omar. All rights reserved.
//

import UIKit
import SwipeCellKit

// This Super class handles swipe deletion of entries
class SwipeViewController: UITableViewController, SwipeTableViewCellDelegate {

    let feature = OptimizelyStuff()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 80
    }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
    // create reusable cell object using Cell component in main.storyboard
      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
      
    // Only allow deletion feature if rollout feature enabled returns true
    if feature.getFeature(key: "managerfunctionality") {
        cell.delegate = self
    }
    
    // return cell object to tableview
      return cell
  }
    
    // what happens when cell is swiped
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
           
           guard orientation == .right else { return nil }
           
           let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
               
               // this is what kicks off the deletion from realm db
               self.updateModel(at: indexPath)
           
           }
           
           // customize the action appearance
           deleteAction.image = UIImage(named: "delete-icon")
           
           return [deleteAction]
           
       }
       
    // allows user to delete via full swipe
       func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
           var options = SwipeOptions()
           options.expansionStyle = .destructive
           return options
       }
       
       func updateModel(at indexPath: IndexPath) {
           // code will be from subclass which is overriding this func
       }

}
