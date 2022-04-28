//
//  InEpxensesViewController.swift
//  degreeProject
//
//  Created by gleba on 22.03.2022.
//

import UIKit
import SwiftUI
import RealmSwift

class InEpxensesViewController: UIViewController {
    var realm = try! Realm()
    var ExpenseResults: Results<ExpenseCategoriesObject>{
        get{return realm.objects(ExpenseCategoriesObject.self)}
    }
    var InExpenseResults: Results<InExpenseObjects>{
        get{return realm.objects(InExpenseObjects.self)}
    }
    @IBOutlet var backToExpenses: UINavigationItem!
    var indexForCategories: Int?
    var indicatorName = false
    var indicatorSumm = false
    @IBOutlet var inExpenseTableView: UITableView!
    //BOTTOM CONSTRAINT
    @IBOutlet var bottomViewConstraint: NSLayoutConstraint!
    @IBOutlet var graphOfExpenses: UIButton!
    @IBAction func showGraphOfExpenses(_ sender: Any) {
    }
    @IBOutlet var plusButton: UIButton!
    //SAVE NEW EXPENSE BUTTON
    @IBOutlet var saveNewExpenseButton: UIButton!
    @IBAction func saveNewExpense(_ sender: Any) {
        let item = realm.objects(ExpenseCategoriesObject.self)[indexForCategories!]
        let items = InExpenseObjects()
        let secondsFromGMT: Int = TimeZone.current.secondsFromGMT()
        var now = Date()
        now = Calendar.current.date(byAdding: .second, value: secondsFromGMT, to: now)!
        try! self.realm.write{
            //            items.expenseCategory = ExpenseResults[indexForCategories!.row].category
            items.expenseDate = now
            items.expenseSumm = summTextfield.text
            items.nameOfExpense = nameTextfield.text
            item.inExpenses.append(items)
            realm.add(item, update: .modified)
        }
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
        inExpenseTableView.reloadData()
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
        
        
        //ADD TEST DATA
        
        func addTestData(){
            let date = Date()
            var now = Calendar.current.date(byAdding: .hour, value: +3, to: date, wrappingComponents: true)
            //            now = Calendar.current.date(byAdding: .day, value: -2, to: now!, wrappingComponents: true)!
            let item = realm.objects(ExpenseCategoriesObject.self)[indexForCategories!]
            let items = InExpenseObjects()
            let minutes = -124
            let calendar = Calendar.current
            let currentMinute = calendar.component(.minute, from: now!)
            try! self.realm.write{
                var yesterday =  Date()
                switch Calendar.current.component(.day, from: now!){
                case 1:
                    yesterday = Calendar.current.date(byAdding: .month, value: -1, to: now!, wrappingComponents: true)!
                    yesterday = Calendar.current.date(byAdding: .day, value: -1, to: yesterday, wrappingComponents: true)!
                default:
                    yesterday = Calendar.current.date(byAdding: .day, value: -1, to: now!, wrappingComponents: true)!
                }
                
                if abs(minutes) >= currentMinute{
                    var hours = 0
                    if abs(minutes)/60>0{
                        hours=minutes/60
                    } else{
                        hours = -1
                    }
                    now = Calendar.current.date(byAdding: .hour, value: hours, to: now!, wrappingComponents: true)
                    now = Calendar.current.date(byAdding: .minute, value: minutes%60, to: now!, wrappingComponents: true)
                } else{
                    now = Calendar.current.date(byAdding: .minute, value: minutes, to: now!, wrappingComponents: true)
                }
                //            items.expenseCategory = ExpenseResults[indexForCategories!.row].category
                items.expenseDate = yesterday
                items.expenseSumm = "1111"
                items.nameOfExpense = "test"
                item.inExpenses.append(items)
                realm.add(item, update: .modified)
            }
            //insert how many minutes u want to get back
            
            
        }
//        addTestData()
        let item = realm.objects(ExpenseCategoriesObject.self)[indexForCategories!]
        backToExpenses.title = item.category
        
        //KEYBOARD NOTIFICATION INIT
        NotificationCenter.default.addObserver(self, selector: #selector(ExpensesViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ExpensesViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //SAVE NEW EXPENSE BUTTON IS ENABLE
        actionView.isHidden = true
        super.viewDidLoad()
        graphOfExpenses.layer.cornerRadius = 24
        saveNewExpenseButton.layer.cornerRadius = 24
        plusButton.layer.cornerRadius = plusButton.frame.size.height/2
        plusButton.clipsToBounds = true
    }
    //TRANSFERING DATA TO GRAPHVIEW
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? GraphicViewController, segue.identifier == "segueToGraphView"{
            vc.categoryIndex = indexForCategories
            vc.isItFromInExpenses = true
            }
    }

    
    
    
}
extension InEpxensesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ExpenseResults[indexForCategories!].inExpenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allExpense") as! AllExpensesTableViewCell
        let item = ExpenseResults[indexForCategories!]
        let items = item.inExpenses.sorted(byKeyPath: "expenseDate",ascending: false)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let secondsFromGMT: Int = TimeZone.current.secondsFromGMT()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: secondsFromGMT)
        cell.forWhat.text = items[indexPath.row].nameOfExpense
        cell.howMuchText.text = "\(Double(items[indexPath.row].expenseSumm!)!)"+" P"
        cell.whenText.text = dateFormatter.string(from: items[indexPath.row].expenseDate!)
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete){
            let item = realm.objects(ExpenseCategoriesObject.self)[indexForCategories!]
            try! self.realm.write{
                self.realm.delete(item.inExpenses.sorted(byKeyPath: "expenseDate", ascending: false)[indexPath.row])
            }
            tableView.reloadData()
        }
    }
    
}
