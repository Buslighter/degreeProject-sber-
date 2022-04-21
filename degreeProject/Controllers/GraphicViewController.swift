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
    var indexArray = [Double]()
    var itIsSingleGraph = Bool()
    var realm = try! Realm()
    var ExpenseResults: Results<ExpenseCategoriesObject>{
        get{return realm.objects(ExpenseCategoriesObject.self)}
    }
    var IncomeResults: Results<IncomeObject>{
        get{return realm.objects(IncomeObject.self)}
    }
    
    override func viewDidLoad() {
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
        makeGraphic(incomeSums: incomeArraySums, incomeDates: incomeArrayDates, indexes: indexArray, expenseSums: expenseArraySums, expenseDates: expenseArrayDates, itIsSingleGraph: itIsSingleGraph, whichButtonSelected: chosenButton!)
    }
    func sumDates(){
        if isItFromInExpenses != nil{
            let dateFormatter = DateFormatter()
            var secondsFromGMT: Int = TimeZone.current.secondsFromGMT()
            dateFormatter.dateFormat = "dd.MM"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: secondsFromGMT)
            if isItFromInExpenses!{
                if ExpenseResults[categoryIndex!].inExpenses.count != 0{
                    let expenseRes = ExpenseResults[categoryIndex!]
                    let expenses = expenseRes.inExpenses.sorted(byKeyPath: "expenseDate",ascending: true)
                    let expenseDatesString = expenses.map{ dateFormatter.string(from: $0.expenseDate!) }
                    var index = Double(0)
                    var summ = 0.0
                    for i in 0..<expenses.count{
                        print(expenses[i].expenseSumm,expenses[i].expenseDate,expenseDatesString[i])
                        if expenses.count>1{
                            if expenses.count-i > 1{
                                summ+=(Double(expenses[i].expenseSumm!)!)
                                if expenseDatesString[i] != expenseDatesString[i+1]{
                                    indexArray.append(index)
                                    index+=1
                                    expenseArrayDates.append(expenses[i].expenseDate!)
                                    expenseArraySums.append(summ)
                                    summ=0
                                }
                            } else{
                                if expenseDatesString[i] != expenseDatesString[i-1]{
                                    indexArray.append(index)
                                    expenseArrayDates.append(expenses[i].expenseDate!)
                                    expenseArraySums.append((Double(expenses[i].expenseSumm!)!))
                                } else{
                                    var lastSumm = expenseArraySums.last! + Double(expenses[i].expenseSumm!)!
                                    expenseArraySums.removeLast()
                                    expenseArraySums.append(lastSumm)
                                }
                                
                            }
                            
                        } else{
                            indexArray.append(Double(i))
                            expenseArrayDates.append(expenses[i].expenseDate!)
                            expenseArraySums.append(Double(expenses[i].expenseSumm!)!)
                        }
                        
                    }
                    itIsSingleGraph = true
                    buttonClicked()
                }
                
            }  else {
                let expenseRes = ExpenseResults
                let expenses = expenseRes.sorted(byKeyPath: "expenseDate",ascending: false)
                let incomeRes = IncomeResults
                let incomes = incomeRes.sorted(byKeyPath: "incomeDate",ascending: false)
                if IncomeResults.count != 0{
                    for i in 0..<incomes.count{
                        incomeArraySums.append(Double(incomes[i].incomeSum!)!)
                        incomeArrayDates.append(incomes[i].incomeDate!)
                    }
                }
                if ExpenseResults.count != 0{
                    for i in 0..<expenses.count{
                        for j in 0..<expenses[i].inExpenses.count{
                            expenseArraySums.append(Double(expenses[i].inExpenses[j].expenseSumm!)!)
                            expenseArrayDates.append(expenses[i].inExpenses[j].expenseDate!)
                        }
                    }
                }
                itIsSingleGraph = false
                buttonClicked()
            }
            
            
        }
    }
    
    
    //MAKING GRAPHIC
    func makeGraphic(incomeSums: [Double], incomeDates: [Date],indexes: [Double],expenseSums: [Double], expenseDates: [Date], itIsSingleGraph: Bool, whichButtonSelected: Int) {
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
        var chartData = LineChartData()
        var expenseDatesString = expenseDates.map{ dateFormatter.string(from: $0) }
        if itIsSingleGraph{
            for i in 0..<expenseSums.count{
                print(indexes[i], expenseSums[i])
                lineChartEntry1.append(ChartDataEntry(x: indexes[i], y: expenseSums[i]))
            }
        } else{
            //            var line1ChartDataSet = LineChartDataSet(entries: lineChartEntry1, label: "Расходы")
            //            line1ChartDataSet.colors = ChartColorTemplates.joyful()
            //            var line2ChartDataSet = LineChartDataSet(entries: lineChartEntry1, label: "Доходы")
            //            line2ChartDataSet.colors = ChartColorTemplates.joyful()
        }
        let line1 = LineChartDataSet(entries: lineChartEntry1)
        chartData.dataSets.append(line1)
        let yAxisStyle = GraphView.leftAxis
        let xAxisStyle = GraphView.xAxis
        yAxisStyle.labelFont = .boldSystemFont(ofSize: 9)
        xAxisStyle.labelFont = .boldSystemFont(ofSize: 12)
        yAxisStyle.setLabelCount(6, force: false)
        yAxisStyle.axisMinimum = 0
        xAxisStyle.axisMinimum = 0
        GraphView.setVisibleXRange(minXRange: 5, maxXRange: 5)
        xAxisStyle.setLabelCount(indexes.count, force: true)
        yAxisStyle.granularity = 1
        GraphView.setVisibleXRangeMinimum(7)
        print(indexes.count, expenseSums.count)
        GraphView.xAxis.labelPosition = .bottom
        //                GraphView.leftAxis = yAxisStyle
        GraphView.xAxis.valueFormatter = IndexAxisValueFormatter(values: expenseDatesString)
        GraphView.xAxis.granularity = 1
        GraphView.rightAxis.enabled = false
        GraphView.data = chartData
        GraphView.fitScreen()
        GraphView.extraRightOffset = 30
    }
    
    
    
}

