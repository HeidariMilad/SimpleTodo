//
//  TodoCell.swift
//  SimpleToDo
//
//  Created by Milad on 5/27/23.
//

import UIKit

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
