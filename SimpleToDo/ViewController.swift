//
//  ViewController.swift
//  SimpleToDo
//
//  Created by Milad on 5/27/23.
//

import UIKit

protocol UpdateDelegate {
    func didUpdate()
}
class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var TodoItems: [TodoObject] = []
    var CompletedItems: [TodoObject] = []
    var delegate: UpdateDelegate?
    
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

    @IBAction func addButton(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "addTaskViewController") as! AddTaskViewController
        vc.delegate = self
        vc.modalPresentationStyle = .pageSheet
        self.present(vc, animated: true)
    }
    @IBAction func filterBtn(){
        
    }
    func fetchAll(){
        DBHelper.readTodo { results in
            self.TodoItems = []
            self.TodoItems = results
            // goto main thread
            Utilities.UI {
                self.tableView.reloadData()
            }
        }
        
        DBHelper.readCompleted { results in
            self.CompletedItems = []
            self.CompletedItems = results
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
extension ViewController: UpdateDelegate {
    func didUpdate() {
        self.fetchAll()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Todo"
        }
        if section == 1 {
            return "Completed"
        }
        return ""
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
           
            return TodoItems.count
        }
        if section == 1 {
            return CompletedItems.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell") as! TodoCell
        var item = TodoObject()
        if indexPath.section == 0 {
            item = TodoItems[indexPath.row]
        }
        if indexPath.section == 1 {
            item = CompletedItems[indexPath.row]
        }
        cell.title.text = item.title
        cell.descriptionNote.text = item.descriptionNote
        cell.isCompleted = item.isCompleted
        
        DBHelper.realmBlock {
            item.index = indexPath.row
        }
        
        cell.descriptionNote?.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell") as! TodoCell
        var item = TodoObject()
        if indexPath.section == 0 {
            item = TodoItems[indexPath.row]
        }
        if indexPath.section == 1 {
            item = CompletedItems[indexPath.row]
        }
        
        DBHelper.realmBlock {
            item.isCompleted = !item.isCompleted
        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
//        })
        cell.isCompleted = !cell.isCompleted
        self.fetchAll()
    }
}

class TodoCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descriptionNote: UILabel!
    @IBOutlet weak var checkBox: UIImageView!
    
    var isCompleted: Bool = false {
        didSet{
            if isCompleted == true {
                self.checkBox.image = UIImage(named: "check-box-checked")
            }else{
                self.checkBox.image = UIImage(named: "check-box-empty")
            }
        }
    }
    
}
