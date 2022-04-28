//
//  ViewController.swift
//  degreeProject
//
//  Created by gleba on 18.03.2022.
//

import UIKit
import Charts
import RealmSwift
class GraphicViewController: UIViewController {
    @IBOutlet var GraphView: LineChartView!
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
        if ExpenseResults[categoryIndex!].inExpenses.count != 0{
            chosenButton = 4
            buttonClicked()
        }
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
                    
//                    var index = Double(0)
//                    var summ = 0.0
//                    for i in 0..<expenses.count{
//                        if expenses.count>1{
//                            if expenses.count-i > 1{
//                                summ+=(Double(expenses[i].expenseSumm!)!)
//                                if expenseDatesString[i] != expenseDatesString[i+1]{
//                                    indexArray.append(index)
//                                    index+=1
//                                    expenseArrayDates.append(expenses[i].expenseDate!)
//                                    expenseArraySums.append(summ)
//                                    summ=0
//                                }
//                            } else{
//                                if expenseDatesString[i] != expenseDatesString[i-1]{
//                                    indexArray.append(index)
//                                    expenseArrayDates.append(expenses[i].expenseDate!)
//                                    expenseArraySums.append((Double(expenses[i].expenseSumm!)!))
//                                } else{
//                                    var lastSumm = expenseArraySums.last! + Double(expenses[i].expenseSumm!)!
//                                    expenseArraySums.removeLast()
//                                    expenseArraySums.append(lastSumm)
//                                }
//
//                            }
//
//                        } else{
//                            indexArray.append(Double(i))
//                            expenseArrayDates.append(expenses[i].expenseDate!)
//                            expenseArraySums.append(Double(expenses[i].expenseSumm!)!)
//                        }
//
//                    }
                    expenseArraySums = embedExpSumm
                    expenseArrayDates = embedExpDate
                    indexArrayInc = embedExpInd
                    itIsSingleGraph = true
                    buttonClicked()
                }
                
            } else {
                var expenseRes = ExpenseResults
//                expenseRes = expenseRes.sorted(byKeyPath: "expenseDate",ascending: true)
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
                
                    
                    itIsSingleGraph = false
                    buttonClicked()
                
            }
        }
    }
    
    
    //MAKING GRAPHIC
    func makeGraphic(incomeSums: [Double], incomeDates: [Date],indexesInc: [Double],indexesExp: [Double],expenseSums: [Double], expenseDates: [Date], itIsSingleGraph: Bool, whichButtonSelected: Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM"
        switch whichButtonSelected{
        case 1:
            dateFormatter.dateFormat = "dd.MM"
        case 2:
            dateFormatter.dateFormat = "dd.MM"
        case 3:
            dateFormatter.dateFormat = "dd.MM"
        case 4:
            dateFormatter.dateFormat = "dd.MM.yyyy"
        default:
            print("button selection Error")
        }
        
        var lineChartEntry1 = [ChartDataEntry]()
        var lineChartEntry2 = [ChartDataEntry]()
        var chartData = LineChartData()
        var expenseDatesString = expenseDates.map{ dateFormatter.string(from: $0) }
        if itIsSingleGraph{
            for i in 0..<expenseSums.count{
                print(indexesInc[i], expenseSums[i])
                lineChartEntry1.append(ChartDataEntry(x: indexesInc[i], y: expenseSums[i]))
            }
            var line1ChartDataSet = LineChartDataSet(entries: lineChartEntry1, label: "Расходы")
            GraphView.xAxis.valueFormatter = IndexAxisValueFormatter(values: expenseDatesString)
        } else{
                var line1ChartDataSet = LineChartDataSet(entries: lineChartEntry1, label: "Расходы")
                line1ChartDataSet.colors = ChartColorTemplates.joyful()
                var line2ChartDataSet = LineChartDataSet(entries: lineChartEntry1, label: "Доходы")
                line2ChartDataSet.colors = ChartColorTemplates.joyful()
                let newDateFormatter = DateFormatter()
            newDateFormatter.dateFormat = "dd.MM.yyyy"
            
            var incomeDatesString = incomeDates.map{ newDateFormatter.string(from: $0) }
            var expenseDatesString = expenseDates.map{ newDateFormatter.string(from: $0) }
            var allDates = [String]()
                var expInd = 0
                var incInd = 0
                
            var index = 0.0
            for i in 0..<(incomeDates.count+expenseDates.count){
                var incCount = incomeDates.count
                var expCount = expenseDates.count
                if incInd==incCount{incCount=0}
                if expInd==expCount{expCount=0}
                if incInd<incomeDates.count || expInd<expenseDates.count{
                    if incCount==0{
                        lineChartEntry2.append(ChartDataEntry(x: index, y: expenseSums[expInd]))
                        allDates.append(dateFormatter.string(from:(expenseDates[expInd])))
                        expInd+=1
                    } else if expCount==0{
                        lineChartEntry1.append(ChartDataEntry(x: index, y: incomeSums[incInd]))
                        allDates.append(dateFormatter.string(from:(incomeDates[incInd])))
                        incInd+=1
                    }else{
                        if incomeDates[incInd]>expenseDates[expInd] && incomeDatesString[incInd] != expenseDatesString[expInd]{
                            lineChartEntry1.append(ChartDataEntry(x: index, y: incomeSums[incInd]))
                            allDates.append(dateFormatter.string(from:(incomeDates[incInd])))
                            incInd+=1
                        } else if incomeDates[incInd]<expenseDates[expInd] && incomeDatesString[incInd] != expenseDatesString[expInd]{
                            lineChartEntry2.append(ChartDataEntry(x: index, y: expenseSums[expInd]))
                            allDates.append(dateFormatter.string(from:(expenseDates[expInd])))
                            expInd+=1
                        } else{
                            lineChartEntry1.append(ChartDataEntry(x: index, y: incomeSums[incInd]))
                            lineChartEntry2.append(ChartDataEntry(x: index, y: expenseSums[expInd]))
                            allDates.append(dateFormatter.string(from:(expenseDates[expInd])))
                            incInd+=1
                            expInd+=1
                        }
                    }
                    index+=1
                } else{
                    break
                }
            }
            GraphView.xAxis.valueFormatter = IndexAxisValueFormatter(values: allDates)
        }
        let line1 = LineChartDataSet(entries: lineChartEntry1)
        let line2 = LineChartDataSet(entries: lineChartEntry2)
        line2.fillColor = NSUIColor.red
        chartData.dataSets.append(line1)
        if itIsSingleGraph != true{chartData.dataSets.append(line2)}
        let yAxisStyle = GraphView.leftAxis
        let xAxisStyle = GraphView.xAxis
        yAxisStyle.labelFont = .boldSystemFont(ofSize: 9)
        xAxisStyle.labelFont = .boldSystemFont(ofSize: 12)
        yAxisStyle.setLabelCount(6, force: false)
        yAxisStyle.axisMinimum = 0
        xAxisStyle.axisMinimum = 0
        GraphView.setVisibleXRange(minXRange: 5, maxXRange: 5)
        xAxisStyle.setLabelCount(indexesInc.count, force: true)
        yAxisStyle.granularity = 1
        GraphView.setVisibleXRangeMinimum(7)
        print(indexesInc.count, expenseSums.count)
        GraphView.xAxis.labelPosition = .bottom
        //                GraphView.leftAxis = yAxisStyle
        
        GraphView.xAxis.granularity = 1
        GraphView.rightAxis.enabled = false
        GraphView.data = chartData
        GraphView.fitScreen()
        GraphView.extraRightOffset = 30
    }
    
    
    
}

