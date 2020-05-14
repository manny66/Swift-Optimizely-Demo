//
//  TSETaskViewController.swift
//  TSE Profiler
//
//  Created by Mansoor Omar on 13/5/20.
//  Copyright © 2020 Mansoor Omar. All rights reserved.
//

import Foundation
import RealmSwift
import Optimizely

class TSETaskViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var tasks: Results<TSETasks>?
    
    var selectedTSE: TSE? {
        didSet{
            loadTasks()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - Add buttod
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new task", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if let currentTSE = self.selectedTSE {
                do {
                    try self.realm.write{
                        
                        let newTask = TSETasks()
                        newTask.title = textField.text!
                        newTask.created = Date()
                        
                        currentTSE.tasks.append(newTask)
                    }
                } catch { print("error saving task: \(error)") }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertField) in
            alertField.placeholder = "What task would you like to do?"
            textField = alertField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //MARK: - load tasks
    
    func loadTasks() {
        
        tasks = selectedTSE?.tasks.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    //MARK: - Tableview Datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TSETaskCell", for: indexPath)
        
        if let task = tasks?[indexPath.row] {
            
            cell.textLabel?.text = task.title
            cell.accessoryType = task.done == true ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No tasks found"
        }
        return cell
    }
    
    //MARK: - Tableview Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let task = tasks?[indexPath.row] {
            
            do{
                try realm.write{
                    task.done = !task.done
                }
            } catch{
                print("unable to mark cell: \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
