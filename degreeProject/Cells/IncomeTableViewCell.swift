//
//  IncomeTableViewCell.swift
//  degreeProject
//
//  Created by gleba on 19.03.2022.
//

import UIKit

class IncomeTableViewCell: UITableViewCell {

    @IBOutlet weak var dateOfIncome: UILabel!
    @IBOutlet weak var incomeAmount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
