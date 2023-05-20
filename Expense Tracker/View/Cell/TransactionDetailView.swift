//
//  TransactionDetailView.swift
//  Expense Tracker
//
//  Created by Punit Kumar on 08/05/23.
//

import SwiftUI
import SwiftUIFontIcon

struct TransactionDetailView: View {
    @EnvironmentObject var transactionViewModel: TransactionListViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var presentDltTxnAlert: Bool = false
    var transaction: Transaction
    
    var body: some View {
        VStack(spacing: 40) {
            Image(getImageNameForAccount())
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            
            VStack {
                Text("For Amount: \(transaction.signedAmount < 0 ? "-" : "")₹\(transaction.amount.formatted())")
                    .bold()
                    .font(.custom("Avenir Black", size: 25.0))
                    .opacity(0.7)
                    .foregroundColor(transaction.type == TransactionType.credit.rawValue ? Color.text : .primary)
                
                HStack(alignment: .top, spacing: 20) {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.icon.opacity(0.3))
                        .frame(width: 50, height: 50)
                        .overlay {
                            FontIcon.text(.awesome5Solid(code: FontAwesomeCode(rawValue: transaction.category.icon) ?? .question), fontsize: 24, color: Color.icon)
                        }
                    
                    VStack(alignment: .leading) {
                        Text(transaction.category.name)
                            .font(.custom("Avenir Black", size: 23.0))
                            .opacity(0.7)
                            .lineLimit(1)
                        
                        Text("\(transaction.type): \(transaction.account)")
                            .opacity(0.7)
                            .font(.custom("Avenir Black", size: 18.0))
                            .foregroundColor(.primary)
                        Text(transaction.dateParsed.getDateFromParsedString())
                            .font(.custom("Avenir Black", size: 18.0))
                            .foregroundColor(.secondary)
                    }
                }
            }
            Button("Delete this Transaction") {
                presentDltTxnAlert = true
            }
            .padding([.leading, .trailing], 15)
            .padding([.top, .bottom], 8)
            .background(.red)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .alert("Confirm Delete", isPresented: $presentDltTxnAlert) {
                Button("Yes, delete this shit!", role: .destructive) {
                    transactionViewModel.userAPIDelegate.removeTransaction(userName: transactionViewModel.userName, transactions: [transaction])
                    dismiss()
                }
                Button("Leave it! duh", role: .cancel) { }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 25)
        .padding(.vertical, 40)
        .multilineTextAlignment(.center)
        .background(customBackground)
        .overlay(alignment: .topTrailing) {
            closeButton
        }
        .transition(.move(edge: .bottom))
    }
    
    func getImageNameForAccount() -> String {
        if transaction.account == AccountType.upi.rawValue {
            return "cost"
        } else if transaction.account == AccountType.bank.rawValue {
           return "debit-card"
        }
        return "expenses"
    }
}

private extension TransactionDetailView {
    
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
        transactionViewModel.userName = transactionViewModel.userName
    }
    
    var closeButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .symbolVariant(.circle.fill)
                .font(.system(size: 35, weight: .bold, design: .rounded))
                .foregroundStyle(.gray.opacity(0.4))
                .padding(8)
        }
    }
    
    var customBackground: some View {
        RoundedCorners(color: Color.systemBackground, tl: 10, tr: 10, bl: 0, br: 0)
            .shadow(color: Color.systemBackground.opacity(0.2), radius: 3)
    }
}

// https://stackoverflow.com/questions/56760335/round-specific-corners-swiftui
struct RoundedCorners: View {
    var color: Color = .blue
    var tl: CGFloat = 0.0
    var tr: CGFloat = 0.0
    var bl: CGFloat = 0.0
    var br: CGFloat = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                
                let w = geometry.size.width
                let h = geometry.size.height

                // Make sure we do not exceed the size of the rectangle
                let tr = min(min(self.tr, h/2), w/2)
                let tl = min(min(self.tl, h/2), w/2)
                let bl = min(min(self.bl, h/2), w/2)
                let br = min(min(self.br, h/2), w/2)
                
                path.move(to: CGPoint(x: w / 2.0, y: 0))
                path.addLine(to: CGPoint(x: w - tr, y: 0))
                path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
                path.addLine(to: CGPoint(x: w, y: h - br))
                path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
                path.addLine(to: CGPoint(x: bl, y: h))
                path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
                path.addLine(to: CGPoint(x: 0, y: tl))
                path.addArc(center: CGPoint(x: tl, y: tl), radius: tl, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
                path.closeSubpath()
            }
            .fill(self.color)
        }
    }
}

struct TransactionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionDetailView(transaction: Transaction(account: AccountType.upi.rawValue, amount: 5000, type: TransactionType.debit.rawValue, category: Category(id: 3, name: "Entertainment", icon: FontAwesomeCode.film.rawValue), isExpense: true))
            .environmentObject(TransactionListViewModel())
    }
}
