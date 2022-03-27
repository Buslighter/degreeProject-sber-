//
//  AllExpensesTableViewCell.swift
//  degreeProject
//
//  Created by gleba on 27.03.2022.
//

import UIKit

class AllExpensesTableViewCell: UITableViewCell {

    @IBOutlet var forWhat: UITextField!
    @IBOutlet var whenText: UITextField!
    @IBOutlet var howMuchText: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
