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
    
    var titles = [ToDoListItem]()
    var notes = [ToDoListItem]()
    var dates = [ToDoListItem]()
    
    //MARK: context for core data
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: set number of cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    //MARK: set data to display in cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as! ItemCell
        cell.itemTitleLabel?.text = titles[indexPath.row].itemTitle!
        cell.itemNotesLabel?.text = notes[indexPath.row].itemNotes!
        cell.dueDateLabel?.text = String(describing: dates[indexPath.row].dueDate!)
        
        // return cell so that Table View knows what to draw in each row
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let addItemVCController = navigationController.topViewController as! addItemVC
        addItemVCController.delegate = self
    }
    
    func fetchAllItems() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDoListItem")
        do {
            let result = try managedObjectContext.fetch(request)
            titles = result as! [ToDoListItem]
            notes = result as! [ToDoListItem]
            dates = result as! [ToDoListItem]
        } catch {
            print("\(error)")
        }
    }
    
    func cancelButtonPressed(by controller: addItemVC) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: When "Add Item" button is pressed
    func itemSaved(by controller: addItemVC, with itemTitle: String, itemNotes: String, dueDate: Date, at indexPath: NSIndexPath?) {
        if let ip = indexPath {
            let title = titles[ip.row]
            title.itemTitle = itemTitle
            let note = notes[ip.row]
            note.itemNotes = itemNotes
            let date = dates[ip.row]
            date.dueDate = dueDate
        } else {
            let title = NSEntityDescription.insertNewObject(forEntityName: "ToDoListItem", into: managedObjectContext) as! ToDoListItem
            title.itemTitle = itemTitle
            titles.append(title)
            let note = NSEntityDescription.insertNewObject(forEntityName: "ToDoListItem", into: managedObjectContext) as! ToDoListItem
            note.itemNotes = itemNotes
            notes.append(note)
            let date = NSEntityDescription.insertNewObject(forEntityName: "ToDoListItem", into: managedObjectContext) as! ToDoListItem
            date.dueDate = dueDate
            dates.append(date)
        }
        do {
            try managedObjectContext.save()
        } catch {
            print("\(error)")
        }
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

