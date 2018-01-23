//
//  addItemVC.swift
//  ToDoList
//
//  Created by Lisa Ryland on 1/22/18.
//  Copyright © 2018 Lisa Ryland. All rights reserved.
//

import UIKit

class addItemVC: UIViewController {
    
    weak var delegate: AddItemVCDelegate?
    var indexPath: NSIndexPath?
    
    //MARK: Form fields
    @IBOutlet weak var itemTitleTextField: UITextField!
    @IBOutlet weak var itemNotesTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    //MARK: Cancel Button
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        print("Form closed")
        delegate?.cancelButtonPressed(by: self)
    }
    
    //MARK: Form submitted
    @IBAction func addItemButtonPressed(_ sender: UIButton) {
        print("Form submitted")
        let itemTitle = itemTitleTextField.text!
        let itemNotes = itemNotesTextField.text!
        let dueDate = dueDatePicker.date
        
        //extracting only date from datepicker
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM/dd/yy"
//        let dateString = dateFormatter.string(from: dueDatePicker.date)
//        let dueDate = dateString
        delegate?.itemSaved(by: self, with: itemTitle, itemNotes: itemNotes, dueDate: dueDate, at: indexPath)
        
//        func itemSaved(by controller: addItemVC, with itemTitle: String, itemNotes: String, dueDate: Date, at indexPath: NSIndexPath?)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
