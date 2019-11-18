//
//  ViewController.swift
//  ToDo
//
//  Created by Patalin on 22/10/2019.
//  Copyright © 2019 Patalin. All rights reserved.
//

//file:///var/mobile/Containers/Data/Application/FCB7BB4E-8A35-4C29-A491-C44FE4CF8F32/Documents/

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    var selectCategory: Category? {
        
        didSet{
            
             loadItems()
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
    }
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    

    override func viewWillAppear(_ animated: Bool) {
        
        title = selectCategory?.name
         
        guard let colorHex = selectCategory?.colour else {fatalError()}
        
        updateNavBar(withHexCode: colorHex)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
       updateNavBar(withHexCode: "1D9BF6")
           
    }
    

    //MARK: NavBar Setup Methods
    
    func updateNavBar (withHexCode colourHexCode: String) {
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller does not exist")}
        
         guard let navBarColour = UIColor(hexString: colourHexCode) else {fatalError()}
                        
                       navBar.barTintColor = navBarColour
                       
                       navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
                       
        //             navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColour, returnFlat: true)]
                        
                       searchBar.barTintColor = navBarColour
        
    }
    
    
    //TODO: Declare numberOfRowsInSection here:
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         
        return todoItems?.count ?? 1
        
        
    }
    
    //TODO: Declare cellForRowAtIndexPath here:
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            if let colour = UIColor(hexString: selectCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                
                cell.backgroundColor = colour
                
            }
            //Ternary operator ->
            //value = condition ? valueIfTrue : valueIfFalse
            
            cell.accessoryType = item.done == true ? .checkmark : .none
            
        } else {
            
            cell.textLabel?.text = "No Items Added"
            
        }
        
        return cell
        
    }
    
    //MARK: TableView Delegates Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            
            do {
                
               try realm.write {
                
                item.done = !item.done
                
                }
                
            } catch {
                    print("Error saving done status, \(error)")
                }
            
            }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
            
        }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Items", message:  "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if let currentCategory = self.selectCategory {
                
                do {
                    
                    try self.realm.write {
                         
                        let newItem = Item()
                        
                        newItem.title = textField.text!
                        
                        newItem.dateCreated = Date()
                        
                        currentCategory.items.append(newItem)
                        
                    }
                    
                } catch {
                    
                    print("Error saving new items \(error)")
                    
                }
                
            }
             
            //What will hapen when the userl will click the Add Item Button on our UIAlert
            
//            let newItem = Item(context: self.context)
//
//            newItem.title = textField.text!
//
//            newItem.done = false
//
//            newItem.parentCategory = self.selectCategory
//
//            self.itemArray.append(newItem)
            
//                self.saveItems()
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
             
            alertTextField.placeholder = "Create New Item"
            
            textField = alertTextField
            
        }
        
        alert.addAction( action)
        
        present( alert, animated: true, completion: nil)
        
    }
    
//    func save(itemSaved: Item) {
//
//        do {
//
//            try realm.write {
//                realm.add(itemSaved)
//            }
//
//        } catch {
//
//            print("Error saving context \(error)")
//
//        }
//
//        self.tableView.reloadData()
//
//    }
    
    func loadItems() {
        
        todoItems = selectCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
         
        if let item = todoItems?[indexPath.row] {
            
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                
                print ("Error deleting items, \(error)")
                
            }
            
        }
        
    }
    
}


//MARK: - Search Bar Methods

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()

//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: predicate)

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

