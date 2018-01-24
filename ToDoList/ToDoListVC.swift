//
//  ToDoListVC.swift
//  ToDoList
//
//  Created by Lisa Ryland on 1/21/18.
//  Copyright © 2018 Lisa Ryland. All rights reserved.
//
import UIKit
import CoreData

class ToDoListVC: UITableViewController, AddItemVCDelegate {
    // items refers to single database entry with title, notes, and date attributes
    var items = [ToDoListItem]()
    
    //MARK: context for core data
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: set number of cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    //MARK: set data to display in cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        let item = items[indexPath.row]
        
        cell.itemTitleLabel?.text = item.itemTitle!
        cell.itemNotesLabel?.text = item.itemNotes!
        
        //extracting only date from datepicker
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        let dateString = dateFormatter.string(from: item.dueDate!)
        cell.dueDateLabel?.text = dateString
        
        //checkmark toggle display
        
        
        // return cell so that Table View knows what to draw in each row
        return cell
    }
    
    // toggle checkmark when cell is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
            }
            else {
                cell.accessoryType = .checkmark
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let addItemVCController = navigationController.topViewController as! addItemVC
        addItemVCController.delegate = self
        
        // if editing, send along the index path to additemVC
    }
    
    func fetchAllItems() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDoListItem")
        do {
            let result = try managedObjectContext.fetch(request)
            items = result as! [ToDoListItem]
        } catch {
            print("\(error)")
        }
    }
    
    func cancelButtonPressed(by controller: addItemVC) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: When "Add Item" button is pressed
    func itemSaved(by controller: addItemVC, with itemTitle: String, itemNotes: String, dueDate: Date) {

        let item = NSEntityDescription.insertNewObject(forEntityName: "ToDoListItem", into: managedObjectContext) as! ToDoListItem
        item.dueDate = dueDate
        item.itemNotes = itemNotes
        item.itemTitle = itemTitle
        
        do {
            try managedObjectContext.save()
        } catch {
            print("\(error)")
        }
        
        items.append(item)
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 100
        fetchAllItems()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
