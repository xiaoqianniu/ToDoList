//
//  ViewController.swift
//  ToDoList
//
//  Created by Hongbo Niu on 2017-12-31.
//  Copyright © 2017 Hongbo Niu. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController{
  let realm = try! Realm()
  var toDoItems:Results<Item>?
    
  var selectedCategory : Category?{
        didSet{
            loadItems()
    }
    }

//let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
    print(FileManager.default.urls(for: .documentDirectory,in: .userDomainMask))
        
      tableView.separatorStyle = .none
      

    }

    // MARK:tableview datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoItems?[indexPath.row]{
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
            
//            adding gradien backgroundcolors and contrast textcolour
            let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat((toDoItems!.count)))
            cell.backgroundColor = colour
            cell.textLabel?.textColor = ContrastColorOf(colour!, returnFlat: true)
            
        }else{
            cell.textLabel?.text = "No new items added"
        }
        return cell
        
    }
    
    //MARK: TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//      *****  how to update the dates using realm
//        ****** how to delete the dates using realm
        if let item = toDoItems?[indexPath.row]{
        do{
            try realm.write {
                item.done = !item.done
                
//             realm.delete(item)
            }
        }catch{
            print("error saving done status \(error)")
            }
        }
        tableView.reloadData()
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)

//        toDoItems[indexPath.row].done = !toDoItems[indexPath.row].done
//        
//        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: add new Item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
       var textField = UITextField()
       let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
       let action = UIAlertAction(title: "Add New Item", style: .default) { (action) in
      //  what will happen once the user click the add Item Button on our UIAlert
        if let currentCategory = self.selectedCategory{
            do{
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                }
            }catch{
                print("error adding new Items \(error)")
            }
           
        }
        
         self.tableView.reloadData()
        
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    // MARK: Model manupulation method
//    func saveItems(){
    
//        do{
//            try context.save()
//        }catch{
//           print("error saving context \(error)")
//        }
//        self.tableView.reloadData()

//    }
    
    func loadItems(){
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()

//        do{
//            itemArray = try context.fetch(request)
//        }catch{
//            print("Error fetching data from context \(error)")
//        }
//        tableView.reloadData()
//
//    }

}

//MARK: delete items from swipe

override func updateModel(at indexPath:IndexPath){
    
    if let itemForDeletion = toDoItems?[indexPath.row]{
        do{
            try realm.write {
                realm.delete(itemForDeletion)
            }
        }catch{
            print("error deleting \(error)")
        }
    }
}
}

//MARK:search bar method

extension TodoListViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
 }
//        let request:NSFetchRequest<Item> = Item.fetchRequest()
//        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request)

   

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
               searchBar.resignFirstResponder()
            }

        }
    }
}


