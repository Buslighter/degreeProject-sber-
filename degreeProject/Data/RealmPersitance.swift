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
}
