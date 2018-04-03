//
//  ViewController.swift
//  TodoList
//
//  Created by mehdi dridi on 3/31/18.
//  Copyright © 2018 mehdi dridi. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoViewController: SwipeTableViewController {
        let realm  = try! Realm()
    var todoItems : Results<Item>?
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none

    }

    //MARK - TableView Data source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    //how should we display each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                 cell.backgroundColor = color
                 cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "no Items Added"
        }
        
        
    
        return cell
    }
    
    
    //MARK - delete data fro swap
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                    //realm.delete(item)
                }
            } catch {
                print("error saving \(error)")
            }
        }
    }
    
    //MARK - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                    //realm.delete(item)
                }
            } catch {
                print("error saving \(error)")
            }
            
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - add new Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "add new todo item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "add item", style: .default){ (action) in
            
            if let currentCategory = self.selectedCategory{
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.dateCreated = Date()
                        newItem.title = textfield.text!
                        currentCategory.items.append(newItem)
                     
                    }
                } catch{
                    print("error \(error)")
                }
            }
        self.tableView.reloadData()
        }
        
        
        alert.addTextField { (alertextField) in
            alertextField.placeholder = "create new item"
            textfield = alertextField
        }
        
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    func saveItems() {
     
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
}

//MARK - Search bar methods
extension TodoViewController: UISearchBarDelegate{

    //find stuff in the database
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text).sorted(byKeyPath: "dateCreated", ascending: true)
       tableView.reloadData()
    }

    //get back to the original list
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}

