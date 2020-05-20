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
class TSETaskViewController: SwipeViewController {
    
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
    
    // get instance of feature class
    let optimizelyStuff = OptimizelyStuff()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // runs when view appears
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // enable search bar if "SearchBar" variation was given
        if let variation = optimizelyStuff.expVariation(key: "search_bar") {
            if variation == "SearchBarTrue" {
                searchBar.isHidden = false
            }
        }
        
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
    
    
    
    //MARK: - Load Data
    // load stored tasks and sort by created date
    
    func loadTasks() {
        tasks = selectedTSE?.tasks.sorted(byKeyPath: "created", ascending: true)
        tableView.reloadData()
    }
    
    
    //MARK: - Delete Data
    
    override func updateModel(at indexPath: IndexPath) {
        if let task = self.tasks?[indexPath.row] {
            do {
                try self.realm.write{
                    self.realm.delete(task)
                }
            } catch {
                print("error when deleting task: \(error)")
            }
        }
    }
    
    
    //MARK: - Tableview Datasource
    
    // gets count of task objects
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks?.count ?? 1
    }
    
    // populates task title in each cell returned
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
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


//MARK: - Search Bar (class extension)

// extends the main class using adoption of delegate protocol
extension TSETaskViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // trigger optimizely event when search is performed
        optimizelyStuff.triggerEvent(event: "used_search")
        
        // filter realm "tasks" objects with search bar text and do an asc sort on title key
        tasks = tasks?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "created", ascending: true)
        
        // reload table with filtered data
        tableView.reloadData()
    }
    
    // resets list of tasks and takes focus out of the search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // run only if there is no text at all
        if searchBar.text?.count == 0 {
            // no argument provided so it will use the default value and load all items
            loadTasks()
            
            // run async in main thread because it could lock up the UI
            DispatchQueue.main.async {
                // the search bard should not be selected with the cursor anymore
                searchBar.resignFirstResponder()
            }
        }
    }
}
