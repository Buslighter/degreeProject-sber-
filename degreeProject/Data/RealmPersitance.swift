//
//  RealmPersitance.swift
//  degreeProject
//
//  Created by gleba on 22.03.2022.
//

import Foundation
import RealmSwift

class IncomeObject: Object{
    @objc dynamic var incomeSum: String?
    @objc dynamic var incomeDate: Date?
}
class ExpenseCategoriesObject: Object{
    @objc dynamic var category: String?
    var inExpenses = List<InExpenseObjects>()
    override static func primaryKey() -> String? {
        return "category"
      }
}

class InExpenseObjects: Object{
    @objc dynamic var nameOfExpense: String?
    @objc dynamic var expenseSumm: String?
    @objc dynamic var expenseDate: Date?
//    @objc dynamic var expenseCategory: ExpenseCategoriesObject?
}
