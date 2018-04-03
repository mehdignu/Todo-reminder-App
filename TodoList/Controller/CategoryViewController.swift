//
//  CategoryViewController.swift
//  TodoList
//
//  Created by mehdi dridi on 4/2/18.
//  Copyright © 2018 mehdi dridi. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
        tableView.separatorStyle = .none
        
        tableView.rowHeight = 80.0
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "add new category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "add Category", style: .default){ (action) in
            
            let newCategory = Category()
            newCategory.name = textfield.text!
            newCategory.color = UIColor.randomFlat.hexValue()
            
            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertextField) in
            alertextField.placeholder = "create new item"
            textfield = alertextField
        }
        
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //Mark - TableView Data Source method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    //how should we display each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        
        
        guard let catColor = UIColor(hexString: categories![indexPath.row].color) else {fatalError()}
        
        cell.backgroundColor = catColor
        cell.textLabel?.textColor = ContrastColorOf(catColor, returnFlat: true)
        return cell
        
        
    }
    
    //MARK - delete data fro swap
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDel = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDel)
                }
            } catch{
                print("error deleting \(error)")
            }
        }
    }
    
    //MARK - TableView Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    func save(category : Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch{
            print("error \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
}


