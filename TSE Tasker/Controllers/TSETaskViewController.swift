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

// handles tasks view
class TSETaskViewController: UITableViewController {
    
    // get realm instance
    let realm = try! Realm()
    
    // get realm Results container of TSETasks
    var tasks: Results<TSETasks>?
    
    // this variable gets populated by TSEListViewController before segque transition
    var selectedTSE: TSE? {
        didSet{
            // loads current task entries
            loadTasks()
        }
    }
    
    // runs when view appears
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - Add buttod
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // create alert popup isntance and an action for it
        let alert = UIAlertController(title: "Add new task", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            // checks if selectedTSE variable has a value
            if let currentTSE = self.selectedTSE {
                // starts realm writing
                do {
                    try self.realm.write{
                        // initialises instance of TSETasks object and popultes properties
                        let newTask = TSETasks()
                        newTask.title = textField.text!
                        newTask.created = Date()
                        
                        // adds the new task created as a relation to the TSE entry it is for
                        currentTSE.tasks.append(newTask)
                    }
                } catch { print("error saving task: \(error)") }
            }
            // refresh tableview with new task
            self.tableView.reloadData()
        }
        
        // add a text field to alert popup
        alert.addTextField { (alertField) in
            alertField.placeholder = "What task would you like to do?"
            textField = alertField
        }
        // add action to alert popup
        alert.addAction(action)
        
        // show the alert popup
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //MARK: - load tasks
    // load stored tasks and sort by created date

    func loadTasks() {
        tasks = selectedTSE?.tasks.sorted(byKeyPath: "created", ascending: true)
        tableView.reloadData()
    }
    
    //MARK: - Tableview Datasource
    
    // gets count of task objects
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks?.count ?? 1
    }
    
    // populates task title in each cell returned
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // gets cell we configured for view in main.storyboard
        let cell = tableView.dequeueReusableCell(withIdentifier: "TSETaskCell", for: indexPath)
        
        // if there are task objects update cell properties with task property values
        if let task = tasks?[indexPath.row] {
            cell.textLabel?.text = task.title
            cell.accessoryType = task.done == true ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No tasks found"
        }
        
        // return the cell to tableView
        return cell
    }
    
    //MARK: - Tableview Delegate
    
    // runs when a cell(task) is clicked
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let task = tasks?[indexPath.row] {
            
            // puts checkmark on if it's off and vice versa
            do{
                try realm.write{
                    task.done = !task.done
                }
            } catch{
                print("unable to mark cell: \(error)")
            }
        }
        // refersh tableview with updates
        tableView.reloadData()
        
        // makes cell flash when clicked
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
