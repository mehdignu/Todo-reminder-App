//
//  ViewController.swift
//  TodoList
//
//  Created by mehdi dridi on 3/31/18.
//  Copyright © 2018 mehdi dridi. All rights reserved.
//

import UIKit

class TodoViewController: UITableViewController {

    var itemArray = [Item]()
    let dataPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadItems()
        
    }

    //MARK - TableView Data source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //how should we display each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoitemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        
        cell.accessoryType = item.done ? .checkmark : .none
    
        return cell
    }
    
    //MARK TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  print(itemArray[indexPath.row])
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
       saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - add new Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "add new todo item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "add item", style: .default){ (action) in
            
            let newItem = Item()
            newItem.title = textfield.text!
            self.itemArray.append(newItem)
            self.saveItems()
        }
        
        alert.addTextField { (alertextField) in
            alertextField.placeholder = "create new item"
            textfield = alertextField
        }
        
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    func saveItems() {
        
        let encoder = PropertyListEncoder()
        
        
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataPath!)
            
        } catch{
            print("error \(error)")
        }
        
        
        self.tableView.reloadData()
    }
    
    func loadItems(){
      
            
            if let data = try? Data(contentsOf: self.dataPath!){
                let decoder = PropertyListDecoder()
                do {
                     itemArray = try decoder.decode([Item].self, from: data)
                } catch{
                    print("error \(error)")
                }
               
            }
    
       
    }
    
    


}

