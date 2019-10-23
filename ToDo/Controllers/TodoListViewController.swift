//
//  ViewController.swift
//  ToDo
//
//  Created by Patalin on 22/10/2019.
//  Copyright © 2019 Patalin. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Find Mike"
        newItem.done = true
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Find Mike"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Find Mike"
        itemArray.append(newItem3)
        
        // Do any additional setup after loading the view.
        
        if let item = defaults.array(forKey: "TodoListArray") as? [Item] {

            itemArray = item

        }
        
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
         
        //print(itemArray[indexPath.row])
        
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
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new To Do Items", message:  "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
             
            //What will hapen when the userl will click the Add Item Button on our UIAlert
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
             
            alertTextField.placeholder = "Create new item"
            
            textField = alertTextField
            
        }
        
        alert.addAction( action)
        
        present( alert, animated: true, completion: nil)
        
    }
    


}

