//
//  ContentView.swift
//  Expense Tracker
//
//  Created by Punit Kumar on 29/04/23.
//

import SwiftUI
import SwiftUICharts

struct ContentView: View {
    var userName: String
    @State private var presentAlert: Bool = false
    @State private var presentInfoAlert: Bool = false
    @State private var presentDltAccAlert: Bool = false
    private var isTxnsExist: Bool {
        return (transactionViewModel.userExpenseModel?.transactions.count ?? 0) > 0
    }
    @EnvironmentObject var transactionViewModel: TransactionListViewModel
    @EnvironmentObject var reloadView: ReloadView
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                if !presentAlert {
                    HStack {
                        Image("hello")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                        Text("Hi! \(transactionViewModel.userName)")
                            .font(.custom("Avenir Black", size: 30.0))
                            .foregroundColor(.primary)
                        Spacer()
                        
                        Image(systemName: "bin.xmark")
                            .onTapGesture {
                                presentDltAccAlert = true
                            }
                            .foregroundColor(Color.red)
                            .alert("Delete your Account", isPresented: $presentDltAccAlert) {
                                Button("Yes, delete this shit!", role: .destructive) {
                                    transactionViewModel.userAPIDelegate.removeUser(userName: transactionViewModel.userName)
                                    Utility.popToRootView()
                                }
                                Button("Leave it! duh", role: .cancel) { }
                            } message: {
                                Text("We dont collect your info like those corporate fuckers you stupid!, still you wanna go?")
                            }
                    }
                    
                    let data = transactionViewModel.accumulateTransactions()
                    
                    if !data.isEmpty, (data.last?.1 ?? 0) > 0 {
                        HStack(spacing: 5) {
                            Text("\(Utility.getCurrentMonth())'s Spendings")
                                .font(.title2)
                                .bold()
                            Image(systemName: "info.circle")
                                .onTapGesture {
                                    presentInfoAlert = true
                                }
                                .foregroundColor(Color.icon)
                                .alert("Your Spendings", isPresented: $presentInfoAlert) {
                                    Button("Got it Fucker.", role: .cancel) { }
                                } message: {
                                    Text("It includes your current month spendings which is your expenses with cummilative spenditure chart.")
                                }
                        }
                        
                        let totalExpense = data.last?.1 ?? 0
                        CardView {
                            VStack(alignment: .leading) {
                                ChartLabel(totalExpense.formatted(.currency(code: "INR")), type: .title, format: "₹%.02f")
                                LineChart()
                            }
                            .id(reloadView.viewId)
                            .background(Color.systemBackground)
                        }
                        .data(data)
                        .chartStyle(ChartStyle(backgroundColor: Color.systemBackground, foregroundColor: ColorGradient(Color.icon.opacity(0.4), Color.icon)))
                        .frame(height: 300)
                    }
                    
                    NavigationLink(destination: AddTransactionView(userName: userName)) {
                        HStack(alignment: .center, spacing: 15) {
                            Image("budget-blue")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                            
                            HStack(alignment: .center, spacing: 2) {
                                Text("Add an Expense")
                                    .font(.headline).bold()
                                Image(systemName: "arrowshape.turn.up.right.fill")
                            }
                            .foregroundColor(Color.text)
                            Spacer()
                        }
                        .padding()
                    }
                    .background()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    if isTxnsExist {
                        RecentTransactionsList()
                    }
                }
            }
            .onAppear {
                reloadView.viewId = UUID()
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
        .alert(userName, isPresented: $presentAlert, actions: {
            NavigationLink("Add one?"){
                AddTransactionView(userName: userName)
            }
            Button("Nope, Get me the Fuck out now", role: .cancel) {
                Utility.popToRootView()
            }
        }, message: {
            Text("No Transactions Exist")
        })
        
        .onAppear {
            transactionViewModel.userName = userName
            if let userExpenseModel = transactionViewModel.userExpenseModel, !userExpenseModel.transactions.isEmpty {
                self.presentAlert = false
            } else {
                self.presentAlert = true
            }
        }
        .background(Color.background)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ContentView_Previews: PreviewProvider {
    static let transactionViewModel: TransactionListViewModel = {
        let transactionViewModel = TransactionListViewModel()
        return transactionViewModel
    }()
    
    static var previews: some View {
        ContentView(userName: "")
            .environmentObject(transactionViewModel)
            .environmentObject(ReloadView())
    }
}
