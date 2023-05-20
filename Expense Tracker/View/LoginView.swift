//
//  LoginView.swift
//  Expense Tracker
//
//  Created by Punit Kumar on 07/05/23.
//

import SwiftUI

struct LoginView: View {
    @State private var userName: String = ""
    @EnvironmentObject var transactionViewModel: TransactionListViewModel
    
    var body: some View {
        NavigationStack {
            List {
                VStack(spacing: 20) {
                    Image("Money-blue")
                        .resizable()
                        .scaledToFill()
                        .padding([.top, .leading, .trailing], 35)
                        .padding(.bottom, 20)
                    
                    VStack(alignment: .leading) {
                        Text("Login")
                            .frame(alignment: .leading)
                            .font(.custom("Avenir Black", size: 30.0))
                        
                        TextField("username", text: $userName)
                            .autocorrectionDisabled(true)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    Button("Login") {
                        transactionViewModel.userName = userName.lowercased()
                    }
                        .padding([.leading, .trailing], 15)
                        .padding([.top, .bottom], 8)
                        .background(.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .background(
                            NavigationLink("", destination: ContentView(userName: userName.lowercased())).opacity(0)
                        )
                        .disabled(userName.isEmpty)
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            .background(Color.background)
        }
        .navigationViewStyle(.stack)
        .accentColor(.primary)
    }
}

struct LoginView_Previews: PreviewProvider {
    static let transactionViewModel: TransactionListViewModel = {
        let transactionViewModel = TransactionListViewModel()
        return transactionViewModel
    }()
    
    static var previews: some View {
        LoginView()
            .environmentObject(transactionViewModel)
    }
}
