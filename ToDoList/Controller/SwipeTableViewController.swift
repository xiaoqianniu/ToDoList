//
//  SwipeTableViewController.swift
//  ToDoList
//
//  Created by Hongbo Niu on 2018-01-30.
//  Copyright © 2018 Hongbo Niu. All rights reserved.
//

import UIKit
import SwipeCellKit

var cell:UITableViewCell?

class SwipeTableViewController: UITableViewController,SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
            guard orientation == .right else { return nil }
            
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                // handle action by updating model with deletion
                
                self.updateModel(at:indexPath)
              
            }
            // customize the action appearance
            deleteAction.image = UIImage(named: "delete-icon")
            
            return [deleteAction]
        }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
    
    cell.delegate = self
    
    return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        
        return options
    }
  

    func updateModel(at indexPath:IndexPath){
//        update date Model
       print("item delete")
    }



}
