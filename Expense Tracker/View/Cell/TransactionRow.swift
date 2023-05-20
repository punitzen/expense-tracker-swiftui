//
//  TransactionRow.swift
//  Expense Tracker
//
//  Created by Punit Kumar on 29/04/23.
//

import SwiftUI
import SwiftUIFontIcon

struct TransactionRow: View {
    @State private var isPresented: Bool = false
    @State private var sheetHeight: CGFloat = .zero
    @EnvironmentObject var reloadView: ReloadView
    var transaction: Transaction
    
    var body: some View {
        HStack(spacing: 20) {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.icon.opacity(0.3))
                .frame(width: 50, height: 50)
                .overlay {
                    FontIcon.text(.awesome5Solid(code: FontAwesomeCode(rawValue: transaction.category.icon) ?? .question), fontsize: 24, color: Color.icon)
                }
            VStack(alignment: .leading, spacing: 6) {
                Text(transaction.category.name)
                    .font(.subheadline).bold()
                    .opacity(0.7)
                    .lineLimit(1)
                Text("\(transaction.type): \(transaction.account)")
                    .font(.footnote)
                    .opacity(0.7)
                    .foregroundColor(.primary)
                Text(transaction.dateParsed.getDateFromParsedString())
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(transaction.signedAmount, format: .currency(code: "INR"))
                .bold()
                .foregroundColor(transaction.type == TransactionType.credit.rawValue ? Color.text : .primary)
        }
        .padding([.top, .bottom], 8)
        .contentShape(Rectangle())
        .onTapGesture {
            isPresented = true
        }
        .sheet(isPresented: $isPresented) {
            reloadView.viewId = UUID()
        } content: {
            TransactionDetailView(transaction: transaction)
                .padding()
                .overlay {
                    GeometryReader { geometry in
                        Color.clear.preference(key: InnerHeightPreferenceKey.self, value: geometry.size.height)
                    }
                }
                .onPreferenceChange(InnerHeightPreferenceKey.self) { newHeight in
                    sheetHeight = newHeight
                }
                .presentationDetents([.height(sheetHeight)])
        }
    }
}

struct InnerHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct TransactionRow_Previews: PreviewProvider {
    static var previews: some View {
        TransactionRow(transaction: Transaction(account: AccountType.other.rawValue, amount: 5000, type: TransactionType.debit.rawValue, category: Category(id: 3, name: "Entertainment", icon: FontAwesomeCode.film.rawValue), isExpense: true))
            .environmentObject(ReloadView())
    }
}
