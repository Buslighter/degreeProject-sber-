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
        blackoutView.isHidden = true
        IncomeTableView.reloadData()
    }
    @IBOutlet weak var blackoutView: UIView!
    //EXIT EDIT BY CLICKING BLACKSCREEN
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
            let items = IncomeObject()
            //insert how many minutes u want to get back
            let minutes = 50
            let calendar = Calendar.current
            try! self.realm.write{
//                let yesterday =  Calendar.current.date(byAdding: .day, value: -2, to: now, wrappingComponents: true)
                if minutes >= calendar.component(.minute, from: now!) {
                    now = Calendar.current.date(byAdding: .hour, value: -1, to: now!, wrappingComponents: true)
                }
                now = Calendar.current.date(byAdding: .minute, value: -(calendar.component(.minute, from: now!)+60-minutes), to: now!, wrappingComponents: true)
                items.incomeDate = now
                items.incomeSum = "60"
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
//        wholeSumm.text = "\(summ)"
        //TIMER
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        addIncomeBut.layer.cornerRadius = CGFloat(18)
        addNewIncomeButton.layer.cornerRadius = CGFloat(18)
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var IncomeTableView: UITableView!
}

extension IncomeViewController:UITableViewDataSource,UITableViewDelegate,delegateHeight{
    func getTBHeight(_ TBHeight: Double) {
//        b = TBHeight
//        print(b)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IncomeResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "incomeCell", for: indexPath) as! IncomeTableViewCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        var formattedDates = [Date]()
        var sums = [String]()
        let items = IncomeResults
        let k = items.count
        for i in 0..<k {
            formattedDates.append(items[i].incomeDate!)
            sums.append(items[i].incomeSum!)
        }
        let combined = zip(formattedDates, sums).sorted {$0.0 > $1.0}
        formattedDates = combined.map {$0.0}
        sums = combined.map {$0.1}
        
        
        let transactionDate = formattedDates[indexPath.row]
        let currentSum = sums[indexPath.row]
        let now = Date()
        let currentTime = Calendar.current.date(byAdding: .hour, value: +3, to: now, wrappingComponents: true)
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: currentTime!, wrappingComponents: true)!
        let preYesterday = Calendar.current.date(byAdding: .day, value: -1, to: yesterday, wrappingComponents: true)!
//        print(yesterday)
        if transactionDate <= preYesterday{
            cell.dateOfIncome.text = dateFormatter.string(from: transactionDate)
        } else if ((transactionDate > preYesterday) && (transactionDate <= yesterday)){
            cell.dateOfIncome.text = "Вчера"
        } else{
            let calendar = Calendar.current
            let currentHour = calendar.component(.hour, from: currentTime!)
            let currentMinute = calendar.component(.minute, from: currentTime!)
            let currentSecond = calendar.component(.second, from: currentTime!)
            let transactionHour = calendar.component(.hour, from: transactionDate)
            let transactionMinute = calendar.component(.minute, from: transactionDate)
            let transactionSecond = calendar.component(.second, from: transactionDate)
            var hour = abs(currentHour-transactionHour)
            var second = abs(currentSecond-transactionSecond)
//            print(currentHour,transactionHour)
            var minute = abs(currentMinute-transactionMinute)
            if ((currentHour-transactionHour)*60+currentMinute-transactionMinute)<60 {
            if minute<=1 && ((currentMinute-transactionMinute)*60+currentSecond-transactionSecond)<60{
                if minute==1{
                    second = 60-second
                }
//                print((currentMinute-transactionMinute)*60+currentSecond-transactionSecond)
//                print(transactionMinute,transactionSecond)
//                print(minute,second)
               
                cell.dateOfIncome.text =  "\(second) сек. назад"
                
//                print("\(second) : \(transactionDate) alala")
                //((currentHour-transactionHour)*60+currentMinute-transactionMinute)<60
            } else{
                if hour==1{
                    minute = 60-minute
                }
                cell.dateOfIncome.text = "\(minute) мин. назад"
//                print(currentHour,currentMinute , transactionHour,transactionMinute, currentTime, transactionDate, currentSum)
            }
            }else{
                cell.dateOfIncome.text =  "\(hour) ч. назад"
            }
        }
        cell.incomeAmount.text = "\(Double(currentSum)!)"
        return cell
    }
    
    
}
