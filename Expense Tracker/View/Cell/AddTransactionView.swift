//
//  AddTransactionView.swift
//  Expense Tracker
//
//  Created by Punit Kumar on 07/05/23.
//

import SwiftUI
import SwiftUIFontIcon

struct AddTransactionView: View {
    let userName: String
    @EnvironmentObject var transactionViewModel: TransactionListViewModel
    @State private var presentAlert: Bool = false
    @State private var presentAlertAmountError: Bool = false
    @State var amount: String = ""
    @State var account: AccountType.RawValue = "UPI"
    @State var type: TransactionType.RawValue = "Debit"
    @State var category: Category = Category(id: 3, name: "Entertainment", icon: FontAwesomeCode.film.rawValue)
    @State var isExpense: Int = 1
    
    var expense: Bool {
        if isExpense == 0 {
            return false
        }
        return true
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                HStack {
                    Text("Amount:")
                    TextField("Amount", text: $amount)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.decimalPad)
                }
                
                HStack {
                    Text("Account:")
                    Picker(account, selection: $account) {
                        ForEach(AccountType.allCases, id: \.rawValue) { accountType in
                            Text(accountType.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    Spacer()
                }
                
                HStack {
                    Text("Transaction:")
                    Picker(type, selection: $type) {
                        ForEach(TransactionType.allCases, id: \.rawValue) { txnType in
                            Text(txnType.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    Spacer()
                }
                
                HStack {
                    Text("Category:")
                    
                    Picker("", selection: $category) {
                        ForEach(Category.all, id: \.id) {
                            Text($0.name).tag($0)
                        }
                    }
                    .pickerStyle(.menu)
                    Spacer()
                }
                
                HStack {
                    Text("Is Expense:")
                    Picker("", selection: $isExpense) {
                        ForEach(0..<2) { num in
                            if num == 1 {
                                Text("True")
                            } else {
                                Text("False")
                            }
                        }
                    }
                    .pickerStyle(.segmented)
                    Spacer()
                }
                .padding(.bottom, 10)
                
                Text("Submit")
                    .onTapGesture {
                        if Double(amount) != nil {
                            transactionViewModel.userAPIDelegate.saveTransaction(userName: self.userName, transactions: [self.getTransaction()])
                            presentAlert = true
                        } else {
                            presentAlertAmountError = true
                        }
                    }
                    .alert("Transaction Added", isPresented: $presentAlert) {
                        Button("Okay") { }
                    }
                    .alert("Please enter correct amount!, stupid bitch", isPresented: $presentAlertAmountError) {
                        Button("Okay") { }
                    }
                    .padding([.leading, .trailing], 12)
                    .padding([.top, .bottom], 5)
                    .background(.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding()
            .frame(maxWidth: .infinity)
            .navigationTitle("Add an Expense")
        }
        .background(Color.background)
    }
    
    func getTransaction() -> Transaction {
        return Transaction(account: self.account, amount: Double(self.amount) ?? 0, type: self.type, category: self.category, isExpense: self.expense)
    }
}

struct AddTransactionView_Previews: PreviewProvider {
    static let transactionViewModel: TransactionListViewModel = {
        let transactionViewModel = TransactionListViewModel()
        return transactionViewModel
    }()
    
    static var previews: some View {
        AddTransactionView(userName: "")
            .environmentObject(transactionViewModel)
    }
}
