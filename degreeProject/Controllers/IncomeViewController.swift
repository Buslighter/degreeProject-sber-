//
//  IncomeViewController.swift
//  degreeProject
//
//  Created by gleba on 18.03.2022.
//

import UIKit
import RealmSwift
class mutatedResults{
    var incomeSum: String?
    var incomeDate: Date?
}
//FUNC TO PROCCES DATE
func makeTimeRight(transactionDate: Date) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.yyyy"
    let secondsFromGMT: Int = TimeZone.current.secondsFromGMT()
    dateFormatter.timeZone = TimeZone(secondsFromGMT: secondsFromGMT)
    var finalString = ""
    let now = Date()
    var currentTime = Calendar.current.date(byAdding: .hour, value: +3, to: now, wrappingComponents: true)
    var yesterday = Date()
    var preYesterday = Date()
    switch Calendar.current.component(.day, from: currentTime!){
    case 1:
        yesterday = Calendar.current.date(byAdding: .month, value: -1, to: currentTime!, wrappingComponents: true)!
        yesterday = Calendar.current.date(byAdding: .day, value: -1, to: yesterday, wrappingComponents: true)!
        preYesterday = Calendar.current.date(byAdding: .day, value: -1, to: yesterday, wrappingComponents: true)!
    case 2:
        yesterday = Calendar.current.date(byAdding: .day, value: -1, to: currentTime!, wrappingComponents: true)!
        preYesterday = Calendar.current.date(byAdding: .month, value: -1, to: yesterday, wrappingComponents: true)!
        preYesterday = Calendar.current.date(byAdding: .day, value: -1, to: preYesterday, wrappingComponents: true)!
    default :
        yesterday = Calendar.current.date(byAdding: .day, value: -1, to: currentTime!, wrappingComponents: true)!
        preYesterday = Calendar.current.date(byAdding: .day, value: -1, to: yesterday, wrappingComponents: true)!
    }
    if transactionDate <= preYesterday{
        finalString = dateFormatter.string(from: transactionDate)
    } else if ((transactionDate > preYesterday) && (transactionDate <= yesterday)){
        finalString = "Вчера"
    } else{
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: currentTime!)
        let currentMinute = calendar.component(.minute, from: currentTime!)
        let currentSecond = calendar.component(.second, from: currentTime!)
        
        let transactionHour = calendar.component(.hour, from: transactionDate)
        let transactionMinute = calendar.component(.minute, from: transactionDate)
        let transactionSecond = calendar.component(.second, from: transactionDate)
        
        var hour = abs(currentHour-transactionHour)
        if transactionHour > currentHour && currentHour >= 0{
            hour = 24-transactionHour+currentHour
        }
        var second = abs(currentSecond-transactionSecond)
        var minute = abs(currentMinute-transactionMinute)
        
        if (hour*60+minute)<60 {
            if minute<=1 && ((currentMinute-transactionMinute)*60+currentSecond-transactionSecond)<60{
                if minute==1{
                    second = 60-second
                }
                finalString =  "\(second) сек. назад"
            } else{
                if hour==1{
                    minute = 60-minute
                }
                finalString = "\(minute) мин. назад"
            }
        }else{
            finalString =  "\(hour) ч. назад"
        }
    }
    return finalString
}

class IncomeViewController: UIViewController {
    @IBOutlet var wholeSumm: UILabel!
    var pIndicator = true
    var summ: Double = 0
    var sortedSums: [String]?
    var sortedDate: [Date]?
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
        isTextfieldFilled(textfield: summTextfield, button: addNewIncomeButton)
    }
    @IBOutlet weak var summTextfield: UITextField!
    @IBOutlet var blackScreenView: UIView!
    @IBOutlet weak var summLabel: UILabel!
    //SAVE NEW INCOME
    @IBOutlet var addNewIncomeButton: UIButton!
    @IBAction func addNewIncome(_ sender: Any) {
        let date = Date()
        let items = IncomeObject()
        try! self.realm.write{
            items.incomeDate = Calendar.current.date(byAdding: .hour, value: +3, to: date, wrappingComponents: true)
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
        UIView.animate(withDuration: 0.3){
            self.blackScreenView.alpha = 0
            self.blackoutView.isHidden = true
        }
        IncomeTableView.reloadData()
    }
    @IBOutlet weak var blackoutView: UIView!
    //EXIT EDIT BY CLICKING BLACKSCREEN
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view == self.blackScreenView{
            UIView.animate(withDuration: 0.3){
                self.blackScreenView.alpha = 0
                self.blackoutView.isHidden = true
            }
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
    //SHOW PANEL WITH INCOME INPUT
    @IBAction func addIncomeAction(_ sender: Any) {
        self.blackoutView.isHidden = false
        UIView.animate(withDuration: 0.3){
            self.blackScreenView.alpha = 0.35
        }
        addNewIncomeButton.isUserInteractionEnabled = false
        addNewIncomeButton.alpha = 0.5
        summLabel.isHidden = true
        super.viewDidLoad()
        func viewDidAppear(animated: Bool) {
            super.viewDidAppear(animated)
            summTextfield.becomeFirstResponder()
        }
        viewDidAppear(animated: true)
    }
    
    //KEYBOARD PUSHES UP VIEW
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 2){
                if self.bottomConstraintInsertView.constant == 0 {
                    self.bottomConstraintInsertView.constant = 0
                    self.bottomConstraintInsertView.constant = keyboardSize.height-49
                }
                
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if bottomConstraintInsertView.constant != 0 {
            bottomConstraintInsertView.constant = 0
        }
    }
    
    @objc func updateTimer(){IncomeTableView.reloadData()}
    override func viewDidLoad() {
        super.viewDidLoad()
        //DATE FOR TEST
        func addTestData(){
            let date = Date()
            var now = Calendar.current.date(byAdding: .hour, value: +3, to: date, wrappingComponents: true)
            //            now = Calendar.current.date(byAdding: .day, value: -2, to: now!, wrappingComponents: true)!
            let items = IncomeObject()
//            print(now)
            //insert how many minutes u want to get back
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
                items.incomeDate = now
                items.incomeSum = "31"
                self.realm.add(items)
            }
        }
        //        addTestData()
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(IncomeViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(IncomeViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let item1 = IncomeResults
        for i in item1{
            summ+=Double(i.incomeSum!)!
        }
        wholeSumm.text = "\(summ)"
        //TIMER
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        addIncomeBut.layer.cornerRadius = 24
        addNewIncomeButton.layer.cornerRadius = 24
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var IncomeTableView: UITableView!
}

extension IncomeViewController:UITableViewDataSource,UITableViewDelegate,delegateHeight{
    func getTBHeight(_ TBHeight: Double) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IncomeResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "incomeCell", for: indexPath) as! IncomeTableViewCell
        
        let item = IncomeResults
        let items = item.sorted(byKeyPath: "incomeDate",ascending: false)
        let transactionDate = items[indexPath.row].incomeDate!
        let currentSum = items[indexPath.row].incomeSum!
        cell.dateOfIncome.text = makeTimeRight(transactionDate: transactionDate)
        cell.incomeAmount.text = "\(Double(currentSum)!)"
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete){
            var items = IncomeResults
            items = items.sorted(byKeyPath: "incomeDate",ascending: false)
            let item = items[indexPath.row]
            try! self.realm.write{
                self.realm.delete(item)
            }
            tableView.reloadData()
        }
    }
    
    
}
