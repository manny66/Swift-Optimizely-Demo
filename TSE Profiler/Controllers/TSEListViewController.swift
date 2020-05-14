//
//  ViewController.swift
//  TSE Profiler
//
//  Created by Mansoor Omar on 13/5/20.
//  Copyright © 2020 Mansoor Omar. All rights reserved.
//

import UIKit
import RealmSwift

class TSEViewController: UITableViewController {

    let role = "tse" // change to "manager" to see rollout
    let realm = try! Realm()
    
    var tses: Results<TSE>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // get current number of tses stored
        let currentTses = realm.objects(TSE.self)
        
        // if there are TSE entries already, then no need to populate dummy data
        if currentTses.count < 1 {
            do{
                try self.realm.write{
                    let tseArray = ["Tommy Hoang", "Ali Baker", "Charles Callaghan", "Michal Fasanek", "Tanka Poudel", "Tom Defeo"]
                    for engineer in tseArray {
                        let tse = TSE()
                        tse.name = engineer
                        tse.role = self.role
                        self.realm.add(tse)
                    }
                }
            } catch {
                print("unable to add new tse: \(error)")
            }
        }
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
        
        return cell
    }
    
    //MARK: - Tableview Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // segue to tasks view
        performSegue(withIdentifier: "TseToTasks", sender: self)
    }
    
    //MARK: - Segue operation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TSETaskViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedTSE = tses?[indexPath.row]
        }
    }
}


