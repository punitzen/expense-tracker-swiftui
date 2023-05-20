//
//  TransactionListViewModel.swift
//  Expense Tracker
//
//  Created by Punit Kumar on 29/04/23.
//

import Foundation
import Combine
import Collections
import SwiftUI

typealias TransactionGroup = OrderedDictionary<String, [Transaction]>
typealias TransactionPrefixSum = [(String, Double)]

protocol UserTransaction {
    func isUserAlreadyExist(userName: String) -> Bool
    func removeUser(userName: String)
    func saveTransaction(userName: String, transactions: [Transaction])
    func getTransactions(userName: String) -> [Transaction]
    func removeTransaction(userName: String, transactions: [Transaction])
    func getUserExpenseModel(userName: String) -> UserExpenseModel?
}

final class TransactionListViewModel: ObservableObject {
    @Published var userName: String = ""
    var userExpenseModel: UserExpenseModel? {
        return getUserExpenseModel(userName: self.userName)
    }
    
    var userAPIDelegate: UserTransaction
    
    private var cancellables = Set<AnyCancellable>()
    
    init(userAPIDelegate: UserTransaction = UserAPIManager()) {
        self.userAPIDelegate = userAPIDelegate
    }
    
    func getUserExpenseModel(userName: String) -> UserExpenseModel? {
        return self.userAPIDelegate.getUserExpenseModel(userName: self.userName)
    }
    
    func groupTransactionByMonths() -> TransactionGroup {
        guard let userExpenseModel = self.userExpenseModel, !userExpenseModel.transactions.isEmpty else { return [:] }
        
        return TransactionGroup(grouping: userExpenseModel.transactions.reversed()) { $0.month }
    }
    
    func accumulateTransactions() -> TransactionPrefixSum {
        // TODO: Improve
        
        guard let userExpenseModel = self.userExpenseModel, !userExpenseModel.transactions.isEmpty else { return [] }
        
        let transactions = userExpenseModel.transactions
        
        var prefixSum = 0.0
        var accumulatedData = TransactionPrefixSum()
        
        guard let indiaTimeZone = TimeZone(identifier: "Asia/Kolkata") else { return [] }
        let calendar = Calendar(identifier: .gregorian)
        let currentDate = Date().addingTimeInterval(TimeInterval(indiaTimeZone.secondsFromGMT()))
        guard let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate)) else { return accumulatedData }
        
        let day = calendar.dateComponents([.day], from: startOfMonth, to: currentDate).day ?? 0
        
        for day in Range(1...day+1) {
            guard let startOfDay = calendar.date(bySetting: .day, value: day, of: startOfMonth), let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startOfDay) else { return [] }
            
            let filteredTransactions = transactions.filter { transaction in
                guard transaction.type == TransactionType.debit.rawValue else { return false }
                let transactionDate = transaction.dateParsed.dateParse()
                return transactionDate >= startOfDay && transactionDate <= endOfDay
            }
            
            let sum = filteredTransactions.reduce(0) { $0 - $1.signedAmount }
            prefixSum += sum
            accumulatedData.append((day.formatted(), prefixSum))
        }
        return accumulatedData
    }
}

class UserAPIManager: UserTransaction {
    private let cacheManager = CacheManager<UserExpenseModel>(cacheFileName: "userExpenses")
    
    private var userExpenses: [UserExpenseModel] {
        return cacheManager.getCachedList()
    }
    
    func isUserAlreadyExist(userName: String) -> Bool {
        for userExpense in userExpenses {
            if userExpense.userName == userName {
                return true
            }
        }
        return false
    }
    
    func getUserExpenseModel(userName: String) -> UserExpenseModel? {
        for userExpense in userExpenses {
            if userExpense.userName == userName {
                return userExpense
            }
        }
        return nil
    }
    
    func removeUser(userName: String) {
        var caches = cacheManager.removeCachedList()
        caches = caches.filter { $0.userName != userName }
        cacheManager.saveByOverride(caches)
    }
    
    func saveTransaction(userName: String, transactions: [Transaction]) {
        var caches = cacheManager.removeCachedList()
        var userExpense = caches.filter { $0.userName == userName }
        caches = caches.filter { $0.userName != userName }
        
        if !userExpense.isEmpty {
            userExpense[0].transactions = userExpense[0].transactions + transactions
            caches.append(userExpense[0])
        } else {
            caches.append(UserExpenseModel(userName: userName, transactions: transactions))
        }
        
        cacheManager.saveByOverride(caches)
    }
    
    func getTransactions(userName: String) -> [Transaction] {
        let userExpense = userExpenses.filter { $0.userName == userName }
        
        return (!userExpense.isEmpty ? userExpense[0].transactions : [])
    }
    
    func removeTransaction(userName: String, transactions: [Transaction]) {
        var caches = cacheManager.removeCachedList()
        var userExpense = caches.filter { $0.userName == userName }
        caches = caches.filter { $0.userName != userName }
        
        if !userExpense.isEmpty {
            for transaction in transactions {
                userExpense[0].transactions = userExpense[0].transactions.filter { $0 != transaction }
            }
            caches.append(userExpense[0])
        }
        
        cacheManager.saveByOverride(caches)
    }
}
