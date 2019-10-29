//
//  ViewController.swift
//  ToDo
//
//  Created by Patalin on 22/10/2019.
//  Copyright © 2019 Patalin. All rights reserved.
//

//file:///var/mobile/Containers/Data/Application/FCB7BB4E-8A35-4C29-A491-C44FE4CF8F32/Documents/

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectCategory: Category? {
        
        didSet{
            
            loadItems()
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
//        loadItems()
        
    }
    
    
    //TODO: Declare numberOfRowsInSection here:
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         
        return itemArray.count
        
        
    }
    
    //TODO: Declare cellForRowAtIndexPath here:
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Ternary operator ->
        //value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        //        if item.done == true {
        //
        //                   cell.accessoryType = .checkmark
        //
        //               } else {
        //
        //                   cell.accessoryType = .none
        //               }
        
        return cell
        
    }
    
    //MARK: TableView Delegates Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //          Line of code above replace the lines of code bellow!!!
        //
        //        if itemArray[indexPath.row].done == false {
        //
        //            itemArray[indexPath.row].done = true
        //
        //        } else {
        //
        //            itemArray[indexPath.row].done = false
        //
        //        }
        
        self.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Items", message:  "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
             
            //What will hapen when the userl will click the Add Item Button on our UIAlert
            
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            
            newItem.done = false
            
            newItem.parentCategory = self.selectCategory
            
            self.itemArray.append(newItem)
            
                self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
             
            alertTextField.placeholder = "Create New Item"
            
            textField = alertTextField
            
        }
        
        alert.addAction( action)
        
        present( alert, animated: true, completion: nil)
        
    }
    
    func saveItems() {
        
        do {
        
             try context.save()
        
        } catch {
            
            print("Error saving context \(error)")
            
        }
        
        self.tableView.reloadData()
        
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {

        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectCategory!.name!)
        
        if let additionalPredicate = predicate {
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
            
        } else {
            
            request.predicate = categoryPredicate
            
        }
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//
//        request.predicate = compoundPredicate
        
        do {
        
         try itemArray = context.fetch(request)
            
        } catch {
            
            print("Error fetching data from context \(error)")
            
        }
        
        tableView.reloadData()
    }
    
    
}


//MARK: - Search Bar Methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
        
//        do {
//
//         try itemArray = context.fetch(request)
//
//        } catch {
//
//            print("Error fetching data from context \(error)")
//
//        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         
        if searchBar.text!.count == 0 {
            
            loadItems()
            
            DispatchQueue.main.async {
                 
                searchBar.resignFirstResponder()
                
            }
            
        }
    }
    
}

