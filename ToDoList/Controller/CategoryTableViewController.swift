//
//  CategoryTableViewController.swift
//  ToDoList
//
//  Created by Hongbo Niu on 2018-01-18.
//  Copyright © 2018 Hongbo Niu. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryTableViewController: SwipeTableViewController{
    
    let realm = try! Realm()
    var categoryArray:Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()

    
       loadCategory()
        
    }
    //    MARK:Tableview datasource method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No new categories yet"
        
        return cell
    }

      //    MARK:Add new categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
    var textfield = UITextField()
    let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
      //what will happen after the users click the button
        let categoryName = Category()
        categoryName.name = textfield.text!
        
        self.save(category: categoryName)
    }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "add new category"
            textfield = alertTextField
        }
     alert.addAction(action)
     present(alert, animated: true, completion: nil)

    }
    
    

    //  MARK:Tableview delegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        context?.delete(categoryArray[indexPath.row])
//        categoryArray.remove(at: indexPath.row)
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
//         save(category: Category)
        tableView.deselectRow(at: indexPath, animated: true)
        
}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    
    //    MARK:Data manipulation method
    
    func save(category:Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("category error saving \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory(){
        
    categoryArray = realm.objects(Category.self)
        
}


//MARK: delete data from swipe

    override func updateModel(at indexPath: IndexPath) {
        
    
        if let categoryForDeletion = self.categoryArray?[indexPath.row]{
                            do{
                                try self.realm.write {
                                    self.realm.delete(categoryForDeletion)
                                }
                            }catch{
                                print("error deleting \(error)")
                            }
                        }
}
}

    

