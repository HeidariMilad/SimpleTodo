//
//  ViewController.swift
//  SimpleToDo
//
//  Created by Milad on 5/27/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var items: [TodoObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Set the estimatedRowHeight to a non-zero number
        self.tableView.estimatedRowHeight = 44.0
        
        // Use automatic dimension for rowHeight
        self.tableView.rowHeight = UITableView.automaticDimension
        
//        addToList(title: "test1", description: "You can modify properties of a Realm object inside of a write transaction in the same way that you would update any other Swift or Objective-C object.")
//        addToList(title: "test1", description: "desc1")
//        addToList(title: "test1", description: "desc1")
        fetchAll()
    }

    func addToList(title: String, description: String) {
        let obj = TodoObject()
        obj.title = title
        obj.descriptionNote = description

        DBHelper.write(object: obj)
    }
    
    func fetchAll(){
        DBHelper.read { results in
            self.items = results
            // goto main thread
            Utilities.UI {
                self.tableView.reloadData()
            }
        }
    }
    
    func removeItem(item: TodoObject) {
        DBHelper.delete(object: item)
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell") as! TodoCell
        let item = items[indexPath.row]
        cell.title.text = item.title
        cell.descriptionNote.text = item.descriptionNote
        cell.isCompleted = item.isCompleted
        
        DBHelper.realmBlock {
            item.index = indexPath.row
        }
        
        cell.descriptionNote?.numberOfLines = 0
        return cell
    }
    
    
}

class TodoCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descriptionNote: UILabel!
    var isCompleted: Bool = false
    
}
