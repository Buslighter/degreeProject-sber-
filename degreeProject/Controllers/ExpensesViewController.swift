//
//  ExpensesViewController.swift
//  degreeProject
//
//  Created by gleba on 18.03.2022.
//

import UIKit
import RealmSwift

func isTextfieldFilled(textfield: UITextField, button: UIButton){
    if textfield.text?.count ?? 0 > 0{
        UIView.animate(withDuration: 0.2){
            button.alpha = 1
            button.isUserInteractionEnabled = true
        }
    } else{ UIView.animate(withDuration: 0.8){
        button.alpha = 0.5
        button.isUserInteractionEnabled = false}
    }
}


class ExpensesViewController: UIViewController {
    var realm = try! Realm()
    var ExpenseResults: Results<ExpenseCategoriesObject>{
            get{return realm.objects(ExpenseCategoriesObject.self)}
    }
    
    @IBOutlet var addNewCategory: UIButton!
    @IBAction func addNewCategory(_ sender: Any) {
        saveCategory.alpha = 0.5
        saveCategory.isUserInteractionEnabled = false
        actionView.isHidden = false
        super.viewDidLoad()
        func viewDidAppear(animated: Bool) {
            super.viewDidAppear(animated)
            categoryNameTextfield.becomeFirstResponder()
        }
        viewDidAppear(animated: true)
    }
    //Input in textfield
    @IBAction func categoryNameChanged(_ sender: Any) {
        if categoryLabel.isHidden{
            categoryLabel.isHidden = false
        }
        isTextfieldFilled(textfield: categoryNameTextfield, button: saveCategory)
    }
    @IBOutlet var bottomNewCategoryExpenseConstraint: NSLayoutConstraint!
    @IBOutlet var alertView: UIView!
    @IBOutlet var actionView: UIView!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var categoryNameTextfield: UITextField!
    //make blackout
    @IBOutlet var blackOutExpenseView: UIView!
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view == self.blackOutExpenseView{
            actionView.isHidden = true
        func viewDidAppear(animated: Bool) {
            
            super.viewDidAppear(animated)
            categoryNameTextfield.resignFirstResponder()
            categoryNameTextfield.text = ""
        }
        viewDidAppear(animated: true)
        }
    }
    
    
    @IBOutlet var expenseTableView: UITableView!
    
    @IBAction func saveCategory(_ sender: Any) {
        let items = ExpenseCategoriesObject()
        try! self.realm.write{
            items.category = categoryNameTextfield.text
            self.realm.add(items)
        }
        categoryNameTextfield.text = ""
        categoryNameTextfield.resignFirstResponder()
        actionView.isHidden = true
        expenseTableView.reloadData()
    }
    
    @IBOutlet var saveCategory: UIButton!
    //Keyboard moves View
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 2){
                if self.bottomNewCategoryExpenseConstraint.constant == 0 {
                let tabBar = MainTabBarController()
                    self.bottomNewCategoryExpenseConstraint.constant = 0
                    self.bottomNewCategoryExpenseConstraint.constant = keyboardSize.height-49
            }
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if bottomNewCategoryExpenseConstraint.constant != 0 {
            bottomNewCategoryExpenseConstraint.constant = 0
            }
//        }
    }
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(ExpensesViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ExpensesViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        
        
        super.viewDidLoad()
        addNewCategory.layer.cornerRadius = 24
        saveCategory.layer.cornerRadius = 24
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let index = expenseTableView.indexPath(for: cell){
            expenseTableView.deselectRow(at: index, animated: true)
            if let vc = segue.destination as? InEpxensesViewController, segue.identifier == "segue"{
                vc.indexForCategories = index
            }
        }
    }


}
extension ExpensesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ExpenseResults.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expenseCell") as! ExpenseTableViewCell
        let item = ExpenseResults[indexPath.row]
        cell.categoryLabel.text = item.category
        return cell
    }
    
    
}
