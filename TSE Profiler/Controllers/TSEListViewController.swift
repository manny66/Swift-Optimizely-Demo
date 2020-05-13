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

    let realm = try! Realm()
    
    var tses: Results<TSE>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if tses?.count == nil {
            do{
                try self.realm.write{
                    let tseArray = ["Tommy Hoang", "Ali Baker", "Charles Callaghan", "Michal Fasanek", "Tanka Poudel", "Tom Defeo"]
                    for engineer in tseArray {
                        let tse = TSE()
                        tse.name = engineer
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
            
            do{
                try self.realm.write{
                    self.realm.add(newTSE)
                }
            } catch {
                print("unable to add new tse: \(error)")
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertField) in
            alertField.placeholder = "TSE name"
            textField = alertField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
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
        // segue to new view
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


