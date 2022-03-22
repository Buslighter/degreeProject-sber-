//
//  ExpensesViewController.swift
//  degreeProject
//
//  Created by gleba on 18.03.2022.
//

import UIKit
import RealmSwift
class ExpensesViewController: UIViewController {
    var realm = try! Realm()
    var IncomeResults: Results<ExpenseCategoriesObject>{
            get{return realm.objects(ExpenseCategoriesObject.self)}
    }
    
    @IBAction func addNewCategory(_ sender: Any) {
        actionView.isHidden = false
        
        
        
    }
    @IBAction func categoryNameChanged(_ sender: Any) {
        if categoryLabel.isHidden{
            categoryLabel.isHidden = false
        }
    }
    @IBOutlet var alertView: UIView!
    @IBOutlet var actionView: UIView!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var categoryNameTextfield: UITextField!
    @IBOutlet var blackOutExpenseView: UIView!
    @IBOutlet var expensesTableView: UIView!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    


}
extension ExpensesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expenseCell") as! ExpenseTableViewCell
        
        
        
        return cell
    }
    
    
}
