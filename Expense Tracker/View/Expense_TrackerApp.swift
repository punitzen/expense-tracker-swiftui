//
//  Expense_TrackerApp.swift
//  Expense Tracker
//
//  Created by Punit Kumar on 29/04/23.
//

import SwiftUI

@main
struct Expense_TrackerApp: App {
    @StateObject var transactionViewModel = TransactionListViewModel()
    @StateObject var reloadView = ReloadView()
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(transactionViewModel)
                .environmentObject(reloadView)
        }
    }
}
