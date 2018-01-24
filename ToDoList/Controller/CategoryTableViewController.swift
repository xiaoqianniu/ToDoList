//
//  CategoryTableViewController.swift
//  ToDoList
//
//  Created by Hongbo Niu on 2018-01-18.
//  Copyright © 2018 Hongbo Niu. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()

       loadCategory()
        
    }
    //    MARK:Tableview datasource method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell")
        cell?.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell!
    }

      //    MARK:Add new categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
    var textfield = UITextField()
    let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
      //what will happen after the users click the button
        let categoryName = Category(context: self.context!)
        categoryName.name = textfield.text!
        self.categoryArray.append(categoryName)
        self.saveCategory()
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
        
         saveCategory()
        tableView.deselectRow(at: indexPath, animated: true)
        
}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    
    //    MARK:Data manipulation method
    
    func saveCategory(){
        do{
            try context?.save()
        }catch{
            print("category error saving \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory(){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do{
            try categoryArray = (context?.fetch(request))!
        }catch{
            print("error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
}
