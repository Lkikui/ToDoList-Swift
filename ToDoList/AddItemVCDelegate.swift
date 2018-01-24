//
//  AddItemVCDelegate.swift
//  ToDoList
//
//  Created by Lisa Ryland on 1/22/18.
//  Copyright © 2018 Lisa Ryland. All rights reserved.
//
import UIKit

protocol AddItemVCDelegate: class {
    func itemSaved(by controller: addItemVC, with itemTitle: String, itemNotes: String, dueDate: Date, at indexPath: IndexPath?)
    func cancelButtonPressed(by controller: addItemVC)
}
