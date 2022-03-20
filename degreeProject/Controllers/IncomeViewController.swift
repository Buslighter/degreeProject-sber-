//
//  IncomeViewController.swift
//  degreeProject
//
//  Created by gleba on 18.03.2022.
//

import UIKit

class IncomeViewController: UIViewController {
    var pIndicator = true
    @IBOutlet weak var bottomConstraintInsertView: NSLayoutConstraint!
    
    @IBOutlet weak var tabBarIncome: UITabBarItem!
    
    
    @IBAction func summTextfieldAction(_ sender: Any) {
        var str = ""
        let P = " Р"
        str = summTextfield.text!
        if pIndicator{
            summTextfield.text! = summTextfield.text! + P
//            str.removeLast()
//            print(str)
            pIndicator = false
        } else{
//            summTextfield.text! = ""
//            print(str.last)
            let index = str.index(ofAccessibilityElement: str.count-1)
            
//            str.remove(at: str.index(str.startIndex, offsetBy: index))
            summTextfield.text! = str + P
//            str = summTextfield.text!
//            str.removeLast()11
        }
        
    }
    @IBOutlet weak var summTextfield: UITextField!
    @IBOutlet weak var summLabel: UILabel!
    @IBAction func addNewIncome(_ sender: Any) {
    
        
        
        
        
        summTextfield.resignFirstResponder()
        blackoutView.isHidden = true
    }
    @IBOutlet weak var blackoutView: UIView!
    @IBOutlet weak var currentBalance: UILabel!
    @IBOutlet weak var addIncomeBut: UIButton!
    @IBAction func addIncomeAction(_ sender: Any) {
        blackoutView.isHidden = false
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
            if bottomConstraintInsertView.constant == 0 {
                let tabBar = MainTabBarController()
                
                
                bottomConstraintInsertView.constant = 0
                bottomConstraintInsertView.constant = keyboardSize.height-tabBarIncome.accessibilityFrame.height
                
                print(tabBar.thisTabBar?.frame.height ?? 0)
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
        
        
        
        addIncomeBut.layer.cornerRadius = CGFloat(18)
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
extension IncomeViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "incomeCell", for: indexPath) as! IncomeTableViewCell
        return cell
    }
    
    
}
