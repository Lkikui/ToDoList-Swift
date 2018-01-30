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
        let taskStatus = item.isCompleted
        
        cell.itemTitleLabel?.text = item.itemTitle!
        cell.itemNotesLabel?.text = item.itemNotes!
        
        //extracting only date from datepicker
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        let dateString = dateFormatter.string(from: item.dueDate!)
        cell.dueDateLabel?.text = dateString
        
        //toggle checkmark display
        if taskStatus {
            cell.textLabel?.text = "\u{2705}"
        }
        else {
            cell.textLabel?.text = "\u{2B1C}"
        }
        
        // return cell so that Table View knows what to draw in each row
        return cell
    }
    
    // toggle isCompleted boolean on cell click
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskObject = self.items[indexPath.row]
        
        taskObject.isCompleted = !taskObject.isCompleted // condensed toggle
    
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print("Cannot save object: \(error), \(error.localizedDescription)")
        }
        
        fetchAllItems()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let addItemVCController = navigationController.topViewController as! addItemVC
        addItemVCController.delegate = self

        // if editing, send along the index path to additemVC
        
        if let indexPath = sender as? IndexPath {
            let item = items[indexPath.row]
            addItemVCController.itemTitle = item.itemTitle!
            addItemVCController.itemNote = item.itemNotes!
            addItemVCController.dueDate = item.dueDate!
            addItemVCController.indexPath = indexPath
        }
    }
    
    func fetchAllItems() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDoListItem")
        do {
            let result = try managedObjectContext.fetch(request)
            items = result as! [ToDoListItem]
        } catch {
            print("\(error)")
        }
        tableView.reloadData()
    }
    
    func cancelButtonPressed(by controller: addItemVC) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: When "Add Item" button is pressed
    func itemSaved(by controller: addItemVC, with itemTitle: String, itemNotes: String, dueDate: Date, at indexPath: IndexPath?) {
        let item: ToDoListItem
        // if indexPath, edit item
        if let ip = indexPath {
            item = items[ip.row]
        
        // add new item
        } else {
            item = NSEntityDescription.insertNewObject(forEntityName: "ToDoListItem", into: managedObjectContext) as! ToDoListItem
            item.isCompleted = false
        }
        
        item.dueDate = dueDate
        item.itemNotes = itemNotes
        item.itemTitle = itemTitle
        
        do {
            try managedObjectContext.save()
        } catch {
            print("\(error)")
        }
        
        fetchAllItems()

        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Edit item when accessory button is tapped
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "listToFormSegue", sender: indexPath)
    }
    
    
    
    //MARK: Remove item by swiping left
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        
        managedObjectContext.delete(item)
        
        do {
            try managedObjectContext.save()
        } catch {
            print("\(error)")
        }
        
        items.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 80
        fetchAllItems()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
