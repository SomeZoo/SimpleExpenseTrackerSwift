//
//  Expense.swift
//  SimpleExpenseTrackerSwift
//

import Foundation
import SwiftData

@Model
class Expense {
    var id: String
    var title: String
    var amount: Double
    var date: Date
    var category: String?
    var note: String?
    
    init(title: String, amount: Double, date: Date, category: String? = nil, note: String? = nil) {
        self.id = UUID().uuidString
        self.title = title
        self.amount = amount
        self.date = date
        self.category = category
        self.note = note
    }
}