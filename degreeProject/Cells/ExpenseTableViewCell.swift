//
//  ExpenseTableViewCell.swift
//  degreeProject
//
//  Created by gleba on 22.03.2022.
//

import UIKit

class ExpenseTableViewCell: UITableViewCell {
    @IBAction func categoryButtonAct(_ sender: Any) {
    }
    @IBOutlet var categoryButton: UIButton!
    @IBOutlet var categoryLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
