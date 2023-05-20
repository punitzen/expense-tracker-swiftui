//
//  TransactionModel.swift
//  Expense Tracker
//
//  Created by Punit Kumar on 29/04/23.
//

import Foundation
import SwiftUIFontIcon

struct UserExpenseModel: Codable, Hashable {
    let userName: String
    var transactions: [Transaction]
}

struct Transaction: Codable, Identifiable, Hashable {
    let id: String
    var account: AccountType.RawValue
    var amount: Double
    var type: TransactionType.RawValue
    var category: Category
    var isExpense: Bool
    var dateParsed: String
    var signedAmount: Double
    var month: String
    
    init(account: AccountType.RawValue, amount: Double, type: TransactionType.RawValue, category: Category, isExpense: Bool) {
        self.id = UUID().uuidString
        self.account = account
        self.amount = amount
        self.type = type
        self.category = category
        self.isExpense = isExpense
        self.dateParsed = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: Date()))?.description ?? (Date().description)
        self.signedAmount = (type == TransactionType.credit.rawValue) ? amount : -amount
        self.month = Utility.getCurrentMonth()
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case account
        case amount
        case type
        case category
        case isExpense
        case dateParsed
        case signedAmount
        case month
    }
}

struct Category: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let icon: FontAwesomeCode.RawValue
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case icon
    }
}

class ReloadView: ObservableObject {
    @Published var viewId = UUID()
}

extension Category {
    static let entertainment = Category(id: 3, name: "Entertainment", icon: FontAwesomeCode.film.rawValue)
    static let foodAndDining = Category(id: 5, name: "Food", icon: FontAwesomeCode.hamburger.rawValue)
    static let home = Category(id: 6, name: "Home", icon: FontAwesomeCode.home.rawValue)
    static let income = Category(id: 7, name: "Income", icon: FontAwesomeCode.dollar_sign.rawValue)
    static let shopping = Category(id: 8, name: "Shopping", icon: FontAwesomeCode.shopping_cart.rawValue)
    static let transfer = Category(id: 9, name: "Transfer", icon: FontAwesomeCode.exchange_alt.rawValue)
    static let groceries = Category(id: 501, name: "Groceries", icon: FontAwesomeCode.shopping_basket.rawValue)
    
    static let all: [Category] = [Category.entertainment, Category.foodAndDining, Category.home, Category.income, Category.shopping, Category.transfer, Category.groceries]
}

enum AccountType: String, CaseIterable {
    case upi = "UPI"
    case bank = "Bank"
    case other = "Other"
}

enum TransactionType: String, CaseIterable {
    case credit = "Credit"
    case debit = "Debit"
}
