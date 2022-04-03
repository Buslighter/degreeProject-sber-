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
    var indicatorName = false
    var indicatorSumm = false
    //BOTTOM CONSTRAINT
    @IBOutlet var bottomViewConstraint: NSLayoutConstraint!
    @IBOutlet var graphOfExpenses: UIButton!
    @IBAction func showGraphOfExpenses(_ sender: Any) {
    }
    @IBOutlet var plusButton: UIButton!
    //SAVE NEW EXPENSE BUTTON
    @IBOutlet var saveNewExpenseButton: UIButton!
    @IBAction func saveNewExpense(_ sender: Any) {
        
        UIView.animate(withDuration: 0.3){
            self.blackoutView.alpha = 0
            self.actionView.isHidden = true
        }
        nameTextfield.resignFirstResponder()
        summTextfield.resignFirstResponder()
        nameTextfield.text = ""
        summTextfield.text = ""
        nameLabel.isHidden = true
        summLabel.isHidden = true
    }
    //TRANSFER TO ADDING EXPENSE
    @IBAction func addNewExpense(_ sender: Any) {
        saveNewExpenseButton.isUserInteractionEnabled = false
        saveNewExpenseButton.alpha = 0.5
        actionView.isHidden = false
        UIView.animate(withDuration: 0.3){self.blackoutView.alpha = 0.3}
        nameTextfield.becomeFirstResponder()
        nameLabel.isHidden = true
        summLabel.isHidden = true
    }
    //NAME BLOCK
    @IBOutlet var nameLabel: UILabel!
    //NameTextfield
    @IBOutlet var nameTextfield: UITextField!
    @IBAction func nameTextFieldEditing(_ sender: Any) {
        isTextfieldsFilled()
    }

    //SUMM BLOCK
    @IBOutlet var summLabel: UILabel!
    //SumTextfield
    @IBOutlet var summTextfield: UITextField!
    @IBAction func summTextfieldEditing(_ sender: Any) {
        summTextfield.becomeFirstResponder()
        isTextfieldsFilled()
    }
    //FUNC TO MAKE BUTTON AVAILABLE AND DISABLE
    func isTextfieldsFilled(){
        if summTextfield.text?.count ?? 0 > 0{
            summLabel.isHidden = false
            indicatorSumm = true
        } else {
            indicatorSumm = false
            summLabel.isHidden = true
        }
        if nameTextfield.text?.count ?? 0 > 0{
            nameLabel.isHidden = false
            indicatorName = true
        } else{
            indicatorName=false
            nameLabel.isHidden = true
        }
        if indicatorSumm&&indicatorName{
            UIView.animate(withDuration: 0.2){
                self.saveNewExpenseButton.alpha = 1
                self.saveNewExpenseButton.isUserInteractionEnabled = true
            }
        } else{ UIView.animate(withDuration: 0.8){
            self.saveNewExpenseButton.alpha = 0.5
            self.saveNewExpenseButton.isUserInteractionEnabled = false}
        }
    }
    //screens for blackout
    @IBOutlet var actionView: UIView!
    @IBOutlet var blackoutView: UIView!
    //blackoutCancel
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view == self.blackoutView{
            UIView.animate(withDuration: 0.3){
                self.blackoutView.alpha = 0
                self.actionView.isHidden = true
            }
        func viewDidAppear(animated: Bool) {
            super.viewDidAppear(animated)
            nameTextfield.resignFirstResponder()
            summTextfield.resignFirstResponder()
            nameTextfield.text = ""
            summTextfield.text = ""
        }
        viewDidAppear(animated: true)
        }
    }
    //KEYBOARD SHOW AND MOVE VIEW UP
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.bottomViewConstraint.constant == 0{
                    UIView.animate(withDuration: 2){
                    self.bottomViewConstraint.constant = keyboardSize.height-60
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    //HIDE KEYBOARD AND MOVE VIEW BACK
    @objc func keyboardWillHide(notification: NSNotification) {
        if bottomViewConstraint.constant != 0 {
                bottomViewConstraint.constant = 0
            }
    }
    //VIEW DID LOAD
    override func viewDidLoad() {
        //KEYBOARD NOTIFICATION INIT
        NotificationCenter.default.addObserver(self, selector: #selector(ExpensesViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ExpensesViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        //SAVE NEW EXPENSE BUTTON IS ENABLE
        
        actionView.isHidden = true
        super.viewDidLoad()
//        self.tabBarController?.tabBar.isHidden=true
        graphOfExpenses.layer.cornerRadius = 24
        saveNewExpenseButton.layer.cornerRadius = 24
        plusButton.layer.cornerRadius = plusButton.frame.size.height/2
        plusButton.clipsToBounds = true
        //
    }

}
extension InEpxensesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allExpense") as! AllExpensesTableViewCell
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete){
//            var items = IncomeResults
//            items = items.sorted(byKeyPath: "incomeDate",ascending: false)
//            let item = items[indexPath.row]
//            try! self.realm.write{
//                self.realm.delete(item)
//            }
            tableView.reloadData()
            
        }
    }
    
}
