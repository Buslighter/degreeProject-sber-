//
//  IncomeViewController.swift
//  degreeProject
//
//  Created by gleba on 18.03.2022.
//

import UIKit
import RealmSwift
class IncomeViewController: UIViewController {
    @IBOutlet var wholeSumm: UILabel!
    var pIndicator = true
    var summ: Double = 0
    @IBOutlet weak var bottomConstraintInsertView: NSLayoutConstraint!
    @IBOutlet weak var tabBarIncome: UITabBarItem!
    var realm = try! Realm()
    var IncomeResults: Results<IncomeObject>{
            get{return realm.objects(IncomeObject.self)}
    }
    var b:Double = 0
    @IBAction func summTextfieldAction(_ sender: Any) {
        
        var str = summTextfield.text
        let lastNumber = summTextfield.text?.last?.wholeNumberValue
        let P = "Р"
        if summTextfield.text!.count != 0{
        str?.removeLast()
        }
        if summLabel.isHidden{
        summLabel.isHidden = false
        }
        if summTextfield.text!.count>=2{
        str?.removeLast()
        }
        if lastNumber != nil{
        summTextfield.text = str!+"\(lastNumber!)"+P
        }
    }
    @IBOutlet weak var summTextfield: UITextField!
    @IBOutlet var blackScreenView: UIView!
    @IBOutlet weak var summLabel: UILabel!
    @IBOutlet var addNewIncomeButton: UIButton!
    @IBAction func addNewIncome(_ sender: Any) {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        print(dateFormatter.string(from: date))
        let items = IncomeObject()
        try! self.realm.write{
            items.incomeDate = "\(dateFormatter.string(from: date))"
            var realmStr = summTextfield.text
            realmStr?.removeLast()
            items.incomeSum = realmStr
            self.realm.add(items)
        }
        
        let item2 = IncomeResults
        self.summ+=Double(item2.last!.incomeSum!)!
        wholeSumm.text = "\(summ)"
        summTextfield.text = ""
        summTextfield.resignFirstResponder()
        blackoutView.isHidden = true
        IncomeTableView.reloadData()
    }
    @IBOutlet weak var blackoutView: UIView!
    //Close InputMode without additing
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view == self.blackScreenView{
        blackoutView.isHidden = true
        func viewDidAppear(animated: Bool) {
            
            super.viewDidAppear(animated)
            summTextfield.resignFirstResponder()
            summTextfield.text = ""
        }
        viewDidAppear(animated: true)
        }
    }
    
    
    
    @IBOutlet weak var currentBalance: UILabel!
    @IBOutlet weak var addIncomeBut: UIButton!
    @IBAction func addIncomeAction(_ sender: Any) {
        blackoutView.isHidden = false
        summLabel.isHidden = true
        super.viewDidLoad()
        func viewDidAppear(animated: Bool) {
            super.viewDidAppear(animated)
            summTextfield.becomeFirstResponder()
        }
        viewDidAppear(animated: true)
        print(bottomConstraintInsertView)
    }
    
    //Keyboard moves View
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 2){
                if self.bottomConstraintInsertView.constant == 0 {
                let tabBar = MainTabBarController()
                    self.bottomConstraintInsertView.constant = 0
                    self.bottomConstraintInsertView.constant = keyboardSize.height-49
            }
                print(self.b)
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if bottomConstraintInsertView.constant != 0 {
            bottomConstraintInsertView.constant = 0
            }
//        }
    }
    
    
    
    @IBOutlet weak var IncomeTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(IncomeViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(IncomeViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let item1 = IncomeResults
        for i in item1{
            summ+=Double(i.incomeSum!)!
        }
        wholeSumm.text = "\(summ)"
        
        
        addIncomeBut.layer.cornerRadius = CGFloat(18)
        addNewIncomeButton.layer.cornerRadius = CGFloat(18)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension IncomeViewController:UITableViewDataSource,UITableViewDelegate,delegateHeight{
    func getTBHeight(_ TBHeight: Double) {
        b = TBHeight
        print(b)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IncomeResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "incomeCell", for: indexPath) as! IncomeTableViewCell
        let item = IncomeResults[indexPath.row]
        cell.dateOfIncome.text = item.incomeDate ?? ""
        cell.incomeAmount.text = "\(Double(item.incomeSum! ?? "0")!)"
        return cell
    }
    
    
}
