//
//  RecentTransactionsList.swift
//  Expense Tracker
//
//  Created by Punit Kumar on 29/04/23.
//

import SwiftUI

struct RecentTransactionsList: View {
    @EnvironmentObject var transactionViewModel: TransactionListViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("Recent Transactions")
                    .bold()
                 
                Spacer()
                
                NavigationLink {
                    TransactionList()
                } label: {
                    HStack(spacing: 4) {
                        Text("See All")
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(Color.text)
                }
            }
            .padding(.top)
            
            if let userExpenseModel = transactionViewModel.userExpenseModel {
                ForEach(Array(userExpenseModel.transactions.reversed().prefix(5).enumerated()), id: \.element) { index, transaction in
                    TransactionRow(transaction: transaction)
                    
                    Divider()
                        .opacity((index == 4) ? 0 : 1)
                }
            }
        }
        .padding()
        .background(Color.systemBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.primary.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

struct RecentTransactionsList_Previews: PreviewProvider {
    static let transactionViewModel: TransactionListViewModel = {
        let transactionViewModel = TransactionListViewModel()
        return transactionViewModel
    }()
    
    static var previews: some View {
        RecentTransactionsList()
            .environmentObject(transactionViewModel)
    }
}
