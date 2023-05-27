//
//  AddTaskViewController.swift
//  SimpleToDo
//
//  Created by Milad on 5/27/23.
//

import UIKit

class AddTaskViewController: UIViewController {

    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextField!
    var delegate: UpdateDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func applyBtn() {
        guard self.titleTF != nil || self.titleTF.text != "" else { return }
        addToList(title: self.titleTF.text!.description, description: self.descriptionTF.text!.description)
    }
    
    func addToList(title: String, description: String) {
        let obj = TodoObject()
        obj.title = title
        obj.descriptionNote = description

        DBHelper.write(object: obj) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.delegate?.didUpdate()
            })
        }
        self.dismiss(animated: true)
    }
}
