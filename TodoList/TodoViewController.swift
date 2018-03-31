//
//  ViewController.swift
//  TodoList
//
//  Created by mehdi dridi on 3/31/18.
//  Copyright © 2018 mehdi dridi. All rights reserved.
//

import UIKit

class TodoViewController: UITableViewController {

    var itemArray = ["make money", "spend less money", "fuck it"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    //MARK - TableView Data source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoitemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
    
        return cell
    }
    
    //MARK TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  print(itemArray[indexPath.row])
        
        
        
        if(tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - add new Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "add new todo item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "add item", style: .default){ (action) in
            self.itemArray.append(textfield.text!)
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertextField) in
            alertextField.placeholder = "create new item"
            textfield = alertextField
        }
        
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    


}

