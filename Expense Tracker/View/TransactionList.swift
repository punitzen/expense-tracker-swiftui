//
//  TransactionList.swift
//  Expense Tracker
//
//  Created by Punit Kumar on 29/04/23.
//

import SwiftUI

struct TransactionList: View {
    @EnvironmentObject var transactionViewModel: TransactionListViewModel
    var body: some View {
        VStack {
            List {
                ForEach(Array(transactionViewModel.groupTransactionByMonths()), id: \.key) { month, transaction in
                    Section {
                        ForEach(transaction) { transaction in
                            TransactionRow(transaction: transaction)
                        }
                    } header: {
                        Text(month)
                    }
                    .listSectionSeparator(.hidden)
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("Transactions")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TransactionList_Previews: PreviewProvider {
    static let transactionViewModel: TransactionListViewModel = {
        let transactionViewModel = TransactionListViewModel()
        return transactionViewModel
    }()
    
    static var previews: some View {
        NavigationView {
            TransactionList()
        }
        .environmentObject(transactionViewModel)
    }
}
