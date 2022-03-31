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
    }
    //TRANSFER TO ADDING EXPENSE
    @IBAction func addNewExpense(_ sender: Any) {
        saveNewExpenseButton.isUserInteractionEnabled = false
        saveNewExpenseButton.alpha = 0.5
        actionView.isHidden = false
        UIView.animate(withDuration: 0.3){self.blackoutView.alpha = 0.3}
        nameTextfield.becomeFirstResponder()
    }
    //NAME BLOCK
    @IBOutlet var nameLabel: UILabel!
    //NameTextfield
    @IBOutlet var nameTextfield: UITextField!
    @IBAction func nameTextFieldEditing(_ sender: Any) {
//
        isTextfieldsFilled()
    }
    
    //SUMM BLOCK
    @IBOutlet var summLabel: UILabel!
    //SumTextfield
    @IBOutlet var summTextfield: UITextField!
    @IBAction func summTextfieldEditing(_ sender: Any) {
        isTextfieldsFilled()
    }
    //FUNC TO MAKE BUTTON AVAILABLE AND DISABLE
    func isTextfieldsFilled(){
        if summTextfield.text?.count ?? 0 > 0{
            indicatorSumm = true
        } else {indicatorSumm = false}
        if nameTextfield.text?.count ?? 0 > 0{
                    indicatorName = true
        } else{indicatorName=false}
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
            nameTextfield.text = ""
        }
        viewDidAppear(animated: true)
        }
    }
    //KEYBOARD SHOW AND MOVE VIEW UP
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 2){
                if self.bottomViewConstraint.constant == 0 {
                    self.bottomViewConstraint.constant = 0
                    self.bottomViewConstraint.constant = keyboardSize.height
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
