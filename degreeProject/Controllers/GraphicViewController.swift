//
//  ViewController.swift
//  degreeProject
//
//  Created by gleba on 18.03.2022.
//

import UIKit
import Charts
import RealmSwift
class dataEntries{
    var category:String?
    var sum:sumsEntries?
    var dateTR:Date?
}
class sumsEntries{
    var incSum:Double?
    var expSum:Double?
}
class GraphicViewController: UIViewController {
    @IBOutlet var GraphView: LineChartView!
    var entries = [dataEntries]()
    var isItFromInExpenses: Bool?
    var categoryIndex: Int?
    var chosenButton: Int?
    var incomeArrayDates = [Date]()
    var incomeArraySums = [Double]()
    var expenseArrayDates = [Date]()
    var expenseArraySums = [Double]()
    var indexArrayInc = [Double]()
    var indexArrayExp = [Double]()
    var itIsSingleGraph = Bool()
    var realm = try! Realm()
    var ExpenseResults: Results<ExpenseCategoriesObject>{
        get{return realm.objects(ExpenseCategoriesObject.self)}
    }
    var IncomeResults: Results<IncomeObject>{
        get{return realm.objects(IncomeObject.self)}
    }
    
    override func viewDidLoad() {
        if isItFromInExpenses==nil{isItFromInExpenses=false}
        if isItFromInExpenses ?? false{
            if ExpenseResults[categoryIndex!].inExpenses.count == 0{
                monthButOut.isEnabled = false
                weekButOut.isEnabled = false
                quarterButOut.isEnabled = false
                allTimeButOut.isEnabled = false
            }else{
                monthButOut.isEnabled = true
                weekButOut.isEnabled = true
                quarterButOut.isEnabled = true
                allTimeButOut.isEnabled = true
            }
        }
        chosenButton = 1
        sumDates()
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBOutlet var weekButOut: UIButton!
    @IBAction func weekButton(_ sender: Any) {
        chosenButton = 1
        buttonClicked()
    }
    
    @IBOutlet var monthButOut: UIButton!
    @IBAction func monthButton(_ sender: Any) {
        chosenButton = 2
        buttonClicked()
    }
    @IBOutlet var quarterButOut: UIButton!
    @IBAction func quarterButton(_ sender: Any) {
        chosenButton = 3
        buttonClicked()
    }
    
    @IBOutlet var allTimeButOut: UIButton!
    @IBAction func allTimeButton(_ sender: Any) {
            chosenButton = 4
            buttonClicked()
    }
    func buttonClicked(){
        makeGraphic(incomeSums: incomeArraySums, incomeDates: incomeArrayDates,indexesInc: indexArrayInc, indexesExp: indexArrayExp, expenseSums: expenseArraySums, expenseDates: expenseArrayDates, itIsSingleGraph: itIsSingleGraph, whichButtonSelected: chosenButton!)
    }
    //FUNC TO SUMM ALL TRANSACTIONS AND DATES
    func allTrans(incomeDates: [Date], incomeTrans: [Double]) -> ([Date],[Double],[Double]){
        var mutatedDates: [Date] = []
        var mutatedTrans: [Double] = []
        var indexArray: [Double] = []
        let dateFormatter = DateFormatter()
        let secondsFromGMT: Int = TimeZone.current.secondsFromGMT()
        dateFormatter.dateFormat = "dd.MM"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: secondsFromGMT)
        let incomeDatesString = incomeDates.map{ dateFormatter.string(from: $0) }
        var summ = 0.0
        var index = 0.0
        for i in 0..<incomeDates.count{
            if incomeDates.count>1{
                if incomeDates.count-i>1{
                    summ+=incomeTrans[i]
                    if incomeDatesString[i] != incomeDatesString[i+1]{
                        indexArray.append(index)
                        index+=1
                        mutatedDates.append(incomeDates[i])
                        mutatedTrans.append(summ)
                        summ=0
                    }
                    
                }else{
                    if incomeDates[i] != incomeDates[i-1]{
                        indexArray.append(index)
                        mutatedDates.append(incomeDates[i])
                        mutatedTrans.append(incomeTrans[i])
                    } else{
                        let lastSumm = mutatedTrans.last! + incomeTrans.last!
                        mutatedTrans.removeLast()
                        mutatedTrans.append(lastSumm)
                    }
                }
            } else{
                indexArray.append(Double(i))
                mutatedTrans.append(incomeTrans[i])
                mutatedDates.append(incomeDates[i])
            }
        }
        
        return (mutatedDates, mutatedTrans,indexArray)
    }
    //WRITE DATA
    func sortDatesIndexes(){
        var incInd = 0
        var expInd = 0
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM"
        func addIncome(category: String, addDate: Date, sum: Double){
            let newEntry = dataEntries()
            let sm = sumsEntries()
            newEntry.category = category
            newEntry.dateTR = addDate
            if category=="Expense"{
                sm.expSum = sum
                newEntry.sum = sm
                expInd+=1
            }else if category=="Income"{
                sm.incSum = sum
                newEntry.sum = sm
                incInd+=1
            }
            entries.append(newEntry)
        }
        for _ in 0..<expenseArraySums.count + incomeArraySums.count{
            let newEntry = dataEntries()
            var incCount = incomeArrayDates.count
            var expCount = expenseArrayDates.count
            if incInd==incCount{incCount=0}
            if expInd==expCount{expCount=0}
            
            //FUNC TO ADD INFO TO CLASS
            
            if incInd<incomeArrayDates.count || expInd<expenseArrayDates.count{
                if incCount==0{
                    addIncome(category: "Expense", addDate: expenseArrayDates[expInd], sum: expenseArraySums[expInd])
                    
                }else if expCount==0{
                    addIncome(category:  "Income", addDate: incomeArrayDates[incInd], sum:  incomeArraySums[incInd])
                    
                }else{
                    if dateFormatter.string(from: incomeArrayDates[incInd]) != dateFormatter.string(from: expenseArrayDates[expInd]){
                        if incomeArrayDates[incInd]<expenseArrayDates[expInd]  {
                            addIncome(category:  "Income", addDate: incomeArrayDates[incInd], sum:  incomeArraySums[incInd])
                            
                        } else {
                            addIncome(category: "Expense", addDate: expenseArrayDates[expInd], sum: expenseArraySums[expInd])
                        }
                        
                    } else{
                        newEntry.category = "Both"
                        newEntry.sum?.incSum = incomeArraySums[incInd]
                        newEntry.sum?.expSum = expenseArraySums[expInd]
                        newEntry.dateTR = incomeArrayDates[incInd]
                        incInd+=1
                        expInd+=1
                        entries.append(newEntry)
                    }
                }
            } else{
                break
            }
        }
    }
    //SUMS ARE GROUPED BY DATES
    func sumDates(){
        if isItFromInExpenses != nil{
            let dateFormatter = DateFormatter()
            let secondsFromGMT: Int = TimeZone.current.secondsFromGMT()
            dateFormatter.dateFormat = "dd.MM"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: secondsFromGMT)
            if isItFromInExpenses!{
                if ExpenseResults[categoryIndex!].inExpenses.count != 0{
                    let expenseRes = ExpenseResults[categoryIndex!]
                    let expenses = expenseRes.inExpenses.sorted(byKeyPath: "expenseDate",ascending: true)
                    let expSum = Array(expenses.map{Double($0.expenseSumm!)!})
                    let expDate = Array(expenses.map{$0.expenseDate!})
                    let (embedExpDate,embedExpSumm,embedExpInd) = allTrans(incomeDates: expDate, incomeTrans: expSum)
                    expenseArraySums = embedExpSumm
                    expenseArrayDates = embedExpDate
                    indexArrayInc = embedExpInd
                    itIsSingleGraph = true
                    buttonClicked()
                }
                
            } else {
                var expenseRes = ExpenseResults
                let incomeRes = IncomeResults
                let incomes = incomeRes.sorted(byKeyPath: "incomeDate",ascending: false)
                var inExpenses = [InExpenseObjects]()
                
                for i in 0..<ExpenseResults.count{
                    for j in 0..<ExpenseResults[i].inExpenses.count{
                        inExpenses.append(ExpenseResults[i].inExpenses[j])
                    }
                }
                
                inExpenses = inExpenses.sorted{$0.expenseDate! < $1.expenseDate!}
                //ПОЛУЧАЕМ ПРЕОБРАЗОВАННЫЕ МАССИВЫ
                var (embedExpDate,embedExpSumm,embedExpInd) = allTrans(incomeDates:  Array(inExpenses.map{$0.expenseDate!}), incomeTrans: Array(inExpenses.map{Double($0.expenseSumm!)!}))
                var (embedIncDate,embedIncSum,embedIncInd) = allTrans(incomeDates:  Array(incomes.map{$0.incomeDate!}), incomeTrans: Array(incomes.map{Double($0.incomeSum!)!}))
                
                indexArrayInc = embedExpInd
                
                expenseArraySums = embedExpSumm
                expenseArrayDates = embedExpDate
                incomeArraySums = embedIncSum
                incomeArrayDates = embedIncDate
                
                sortDatesIndexes()
                itIsSingleGraph = false
                buttonClicked()
                
            }
        }
    }
    
    
    //MAKING GRAPHIC
    func makeGraphic(incomeSums: [Double], incomeDates: [Date],indexesInc: [Double],indexesExp: [Double],expenseSums: [Double], expenseDates: [Date], itIsSingleGraph: Bool, whichButtonSelected: Int) {
        let dateFormatter = DateFormatter()
        let yAxisStyle = GraphView.leftAxis
        let xAxisStyle = GraphView.xAxis
//        GraphView.xAxis.granularity = 1
        GraphView.rightAxis.enabled = false
        yAxisStyle.labelFont = .boldSystemFont(ofSize: 9)
        xAxisStyle.labelFont = .boldSystemFont(ofSize: 12)
        yAxisStyle.setLabelCount(6, force: false)
        yAxisStyle.axisMinimum = 0
        xAxisStyle.axisMinimum = 0
        GraphView.setVisibleXRange(minXRange: 5, maxXRange: 10)
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let secondsFromGMT: Int = TimeZone.current.secondsFromGMT()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: secondsFromGMT)
        var now = Date()
        now = Calendar.current.date(byAdding: .second, value: secondsFromGMT, to: now)!
        var modifiedEntries = [dataEntries]()
        
        func calculateEntries(value: Calendar.Component, dateForm: String ){
            var k = 0
            if dateForm=="dd.MM"{k = 4}
            for i in 0..<entries.count{
                if (dateFormatter.calendar.component(value, from: entries[i].dateTR!)-dateFormatter.calendar.component(value, from: now))<k{
                    modifiedEntries.append(entries[i])
                }
            }
            dateFormatter.dateFormat = dateForm
        }
        switch whichButtonSelected{
        case 1:
            calculateEntries(value: .weekday, dateForm: "EEEE")
        case 2:
            calculateEntries(value: .month, dateForm: "dd")
        case 3:
            calculateEntries(value: .month, dateForm: "dd.MM")
        case 4:
            calculateEntries(value: .year, dateForm: "dd.MM.yyyy")
        default:
            print("button selection Error")
        }
        var lineChartEntry1 = [ChartDataEntry]()
        var lineChartEntry2 = [ChartDataEntry]()
        var chartData = LineChartData()
        var expenseDatesString = expenseDates.map{ dateFormatter.string(from: $0) }
        if itIsSingleGraph{
            for i in 0..<expenseSums.count{
                lineChartEntry1.append(ChartDataEntry(x: indexesInc[i], y: expenseSums[i]))
            }
            GraphView.xAxis.valueFormatter = IndexAxisValueFormatter(values: expenseDatesString)
        } else{
            for i in 0..<entries.count{
                if entries[i].category=="Expense"{
                    lineChartEntry1.append(ChartDataEntry(x: Double(i), y: (entries[i].sum?.expSum)!))
                } else if entries[i].category=="Income"{
                    lineChartEntry2.append(ChartDataEntry(x: Double(i), y: (entries[i].sum?.incSum)!))
                } else{
                    lineChartEntry1.append(ChartDataEntry(x: Double(i), y: (entries[i].sum?.expSum)!))
                    lineChartEntry2.append(ChartDataEntry(x: Double(i), y: (entries[i].sum?.incSum)!))
                }
            }
            let allDates = entries.map{$0.dateTR!}
            let allDatesStr=allDates.map{dateFormatter.string(from: $0)}
            GraphView.xAxis.valueFormatter = IndexAxisValueFormatter(values: allDatesStr)
            
        }
        let line1 = LineChartDataSet(entries: lineChartEntry1,label: "Расходы")
        let line2 = LineChartDataSet(entries: lineChartEntry2, label: "Доходы")
        line1.colors = [NSUIColor.red]
        line1.circleColors = [NSUIColor.red]
        if itIsSingleGraph{
            chartData.dataSets.append(line1)
            }
        else{
            chartData.dataSets.append(contentsOf: [line1,line2])
        }
       
        xAxisStyle.setLabelCount(indexesInc.count, force: true)
        yAxisStyle.granularity = 1
        GraphView.setVisibleXRangeMinimum(7)
        GraphView.xAxis.labelPosition = .bottom
        
      
        GraphView.data = chartData
        GraphView.fitScreen()
        GraphView.extraRightOffset = 30
    }
    
    
    
}

