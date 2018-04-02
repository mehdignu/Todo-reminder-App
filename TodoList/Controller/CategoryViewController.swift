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

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "add new category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "add Category", style: .default){ (action) in
            
            let newCategory = Category()
            newCategory.name = textfield.text!
            
            
            
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        
        return cell
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


//MARK - Search bar methods
//extension CategoryViewController: UISearchBarDelegate{
//
//    //find stuff in the database
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request : NSFetchRequest<Category> = Category.fetchRequest()
//        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
//
//        loadItems(with: request)
//    }
//
//    //get back to the original list
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItems()
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//
//        }
//    }
//}
