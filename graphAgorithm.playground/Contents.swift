import UIKit
var expenseArrayDates:[Date] = []
var expenseArraySums:[Double] = []


func allTrans(incomeDates: [Date], incomeTrans: [Double]) -> ([Date],[Double],[Double]){
    var mutatedDates: [Date] = []
    var mutatedTrans: [Double] = []
    var indexArray: [Double] = []
    var summ = 0.0
    var index = 0.0
    for i in 0..<incomeDates.count{
        if incomeDates.count>1{
            if incomeDates.count-i>1{
                summ+=incomeTrans[i]
                if incomeDates[i] != incomeDates[i+1]{
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
allTrans(incomeDates: [Date(timeIntervalSinceReferenceDate: -100000.0),Date(timeIntervalSinceReferenceDate: -100000.0),Date(timeIntervalSinceReferenceDate: -100000.0),Date(timeIntervalSinceReferenceDate: -20000.0)], incomeTrans: [10000.0,3000.0,2200.0,100.0])
