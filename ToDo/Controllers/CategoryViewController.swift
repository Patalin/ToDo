//
//  CategoryViewController.swift
//  ToDo
//
//  Created by Patalin on 25/10/2019.
//  Copyright © 2019 Patalin. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categoryArray : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadCategory()
        tableView.separatorStyle = .none

    }
    
        //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
             
             performSegue(withIdentifier: "goToItems", sender: self)
             
         }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectCategory = categoryArray?[indexPath.row]
            
        }
    }
    
        //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return categoryArray?.count  ?? 1

    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let item = categoryArray?[indexPath.row]
        
        cell.textLabel?.text = item?.name ?? "No Categories Added"
        
        cell.backgroundColor = UIColor(hexString: categoryArray?[indexPath.row].colour ?? "1D9BF6")
        
        return cell

    }
    
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message:  "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
             
            //What will hapen when the userl will click the Add Item Button on our UIAlert
            
            let newCategory = Category()
            
            newCategory.name = textField.text!
            let tempcolor = UIColor.randomFlat()
            newCategory.colour = tempcolor.hexValue()
            
            
            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
             
            alertTextField.placeholder = "Create New Category"
            
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present( alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        
        do {
        
            try realm.write {
                realm.add(category)
            }
        
        } catch {
            
            print("Error saving context \(error)")
            
        }
        
        self.tableView.reloadData()
        
    }
    
    func loadCategory() {
        
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
        
        }
    
    //MARK: Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
         
                    if let categoryForDeletion = self.categoryArray?[indexPath.row] {
        
                        do {
                            try self.realm.write {
        
                                self.realm.delete(categoryForDeletion)
        
                                       }
                        } catch {
        
                            print("Error deleting category, \(error)")
                        }
        
        
                    }
        
    }
    
}

