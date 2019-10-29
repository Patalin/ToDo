//
//  CategoryViewController.swift
//  ToDo
//
//  Created by Patalin on 25/10/2019.
//  Copyright © 2019 Patalin. All rights reserved.
//

import UIKit
import CoreData


class CategoryViewController: UITableViewController {
    
   var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()

    }
    
        //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
             
             performSegue(withIdentifier: "goToItems", sender: self)
             
         }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectCategory = categoryArray[indexPath.row]
            
        }
        
    }
    
        //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return categoryArray.count

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let item = categoryArray[indexPath.row]
        
        cell.textLabel?.text = item.name
        
        return cell

    }
    
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message:  "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
             
            //What will hapen when the userl will click the Add Item Button on our UIAlert
            
            let newCategory = Category(context: self.context)
            
            newCategory.name = textField.text!
            
            self.categoryArray.append(newCategory)
            
            self.saveCategory()
        }
        
        alert.addTextField { (alertTextField) in
             
            alertTextField.placeholder = "Create New Category"
            
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present( alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveCategory() {
        
        do {
        
             try context.save()
        
        } catch {
            
            print("Error saving context \(error)")
            
        }
        
        self.tableView.reloadData()
        
    }
    
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
            
            do {
            
             try categoryArray = context.fetch(request)
                
            } catch {
                
                print("Error fetching data from context \(error)")
                
            }
            
            tableView.reloadData()
        }
    
    
}
