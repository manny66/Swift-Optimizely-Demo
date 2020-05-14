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

class TSEViewController: UITableViewController {

    @IBOutlet weak var barButtonAdd: UIBarButtonItem!
    
    let realm = try! Realm()
    var tses: Results<TSE>?
    
    // get instance of TSEDummy
    let tseDummy = TSEDummy()
    
    // used for creating new tse entries
    let role = "tse" // change to "manager" to see rollout
    
    // pass in when getting feature flag
    let userId = "123" // change this if you modify the feature flag
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide add button if not a manager
        if managerFeature() == false {
            self.navigationItem.rightBarButtonItem = nil
        }
        
        // load dummy data if there aren't any entries yet
        tseDummy.populate()
        
        // get the existing entries stored and reload table with it
        loadTses()
    }

    //MARK: - Add button
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new TSE", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (alert) in
                        
            let newTSE = TSE()
            newTSE.name = textField.text!
            newTSE.role = self.role
            
            self.save(with: newTSE)
        }
        
        alert.addTextField { (alertField) in
            alertField.placeholder = "TSE name"
            textField = alertField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Save data
    func save(with tse: TSE) {
        
        do {
            try self.realm.write{
                self.realm.add(tse)
            }
        } catch {
            print("unable to add new tse: \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - managerFeature
    //new section created
    
    func managerFeature () -> Bool {
        
        let delegate = UIApplication.shared.delegate as! AppDelegate

        let attributes: [String: Any] = [ "userRole": self.role ]
        
        let enabled = delegate.optimizely.isFeatureEnabled(featureKey: "managerfunctionality", userId: userId, attributes: attributes)
        
        print("Feature is enabled? - \(enabled) for userId: \(userId)")

        return enabled
    }
    
    
    //MARK: - Load TSEs

    func loadTses() {
        tses = realm.objects(TSE.self)
        tableView.reloadData()
    }
    
    //MARK: - Tableview Datasource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tses?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell = tableView.dequeueReusableCell(withIdentifier: "TSECell", for: indexPath)
        
        cell.textLabel?.text = tses?[indexPath.row].name ?? "no tse's listed"
        
        // make cell look clickable if they get feature
        if managerFeature() {
            cell.accessoryType = .detailDisclosureButton
        }
        
        return cell
    }
    
    //MARK: - Tableview Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // check if featured is enabled for them
        if managerFeature() {
            
        // segue to tasks view
        performSegue(withIdentifier: "TseToTasks", sender: self)
            
        } else {
            // make cell flash
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    //MARK: - Segue operation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TSETaskViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedTSE = tses?[indexPath.row]
        }
    }
}


