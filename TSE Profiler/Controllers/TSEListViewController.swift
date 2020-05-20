//
//  ViewController.swift
//  TSE Profiler
//
//  Created by Mansoor Omar on 13/5/20.
//  Copyright © 2020 Mansoor Omar. All rights reserved.
//

import UIKit
import RealmSwift
import Optimizely

// handles TSE list view
class TSEViewController: SwipeViewController {
    
    @IBOutlet weak var barButtonAdd: UIBarButtonItem!
    
    // get realm instance
    let realm = try! Realm()
    
    // get realm Results container of TSE objects
    var tses: Results<TSE>?
    
    // get instance of TSEDummy
    let tseDummy = TSEDummy()
    
    // get instance of feature class
    let optimizelyStuff = OptimizelyStuff()
    
    
    // Runs when the UI for view has loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide the add "+" button if the rollout feature is enabled (they are a manager)
        if optimizelyStuff.getFeature(key: "managerfunctionality") == false {
            self.navigationItem.rightBarButtonItem = nil
        }
        
        // activate experiment
        _ = optimizelyStuff.expActivate(key: "search_bar")
        
        // load dummy data if there aren't any entries yet
        tseDummy.populate()
        
        // get the existing entries stored and reload table with it
        loadTses()
        
    }
    
    //MARK: - Add button
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // initialise new text field instance
        var textField = UITextField()
        
        // create popup alert and action
        let alert = UIAlertController(title: "Add new TSE", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (alert) in
            
            // create new instance of TSE and specify properties
            let newTSE = TSE()
            newTSE.name = textField.text!
            newTSE.role = self.optimizelyStuff.role // role prop not used for anything yet
            
            // call save function which will save new TSE entry to realm DB
            self.save(with: newTSE)
        }
        
        // Add text field to the alert
        alert.addTextField { (alertField) in
            alertField.placeholder = "TSE name"
            textField = alertField
        }
        
        // Add the action to alert
        alert.addAction(action)
        
        // show the popup alert
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Load Data
    
    // gets the objects in realm DB of type "TSE" and loads it
    func loadTses() {
        tses = realm.objects(TSE.self)
        tableView.reloadData()
    }
    
    //MARK: - Save data
    func save(with tse: TSE) {
        
        // write into realm DB with the passed in parameter
        do {
            try self.realm.write{
                self.realm.add(tse)
            }
        } catch {
            print("unable to add new tse: \(error)")
        }
        // reload table cells to show the new entry
        tableView.reloadData()
    }
    
    //MARK: - Delete Data
    
    override func updateModel(at indexPath: IndexPath) {
        if let tse = self.tses?[indexPath.row] {
            do {
                try self.realm.write{
                    self.realm.delete(tse)
                }
            } catch {
                print("error when deleting tse: \(error)")
            }
        }
    }
    
    
    //MARK: - Tableview Datasource
    
    // returns number of cells required for tableview
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If there are no TSE objects then return default of 1 cell
        return tses?.count ?? 1
    }
    
    // populates data for every cell returned above and returns it to table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        // display the tse name property at this row, otherwise show string
        cell.textLabel?.text = tses?[indexPath.row].name ?? "no tse's listed"
        
        // UI element for each cell
        cell.accessoryType = .disclosureIndicator
        
        // return the current cell to tableView
        return cell
    }
    
    //MARK: - Tableview Delegate
    
    // what happens when a cell/row is clicked
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // segue/transition to the tasks view
        performSegue(withIdentifier: "TseToTasks", sender: self)
        
    }
    
    //MARK: - Segue operation
    
    // Happens before segue is performed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // make our destination the TASK controller
        let destinationVC = segue.destination as! TSETaskViewController
        
        // pass in the current TSE object to the variable in next controller "selectedTSE"
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedTSE = tses?[indexPath.row]
        }
    }
}


