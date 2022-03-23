//
//  InEpxensesViewController.swift
//  degreeProject
//
//  Created by gleba on 22.03.2022.
//

import UIKit
import SwiftUI

class InEpxensesViewController: UIViewController {
    var indexForCategories: IndexPath?

    @IBAction func showGraphOfExpenses(_ sender: Any) {
    }
    @IBOutlet var plusButton: UIButton!
    
    @IBAction func addNewExpense(_ sender: Any) {
        
    }
    



    override func viewDidLoad() {
        super.viewDidLoad()

        plusButton.layer.cornerRadius = plusButton.frame.size.width/2
        plusButton.clipsToBounds = true
    }

}
