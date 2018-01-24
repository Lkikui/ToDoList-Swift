# ToDoList-Swift
To do list application with data persistence and form to add to the list.

Features:
- Sends data from form view controller to first table view controller with to do list. 
- data is stored in database with attributes title, notes, and date for it to persist after app is closed.
  - date is extracted from datepicker data (which includes a full timestamp)
  - reformatted date for readability
- checkmark toggle to check off to do list items once completed
- persistence of checkmark toggle status
- edit list item
- delete list item by swiping left
