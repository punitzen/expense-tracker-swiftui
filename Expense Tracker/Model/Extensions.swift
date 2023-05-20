//
//  Extensions.swift
//  Expense Tracker
//
//  Created by Punit Kumar on 29/04/23.
//

import Foundation
import SwiftUI

extension Color {
    static let background = Color("Background")
    static let icon = Color("Icon")
    static let text = Color("Text")
    static let systemBackground = Color(uiColor: .systemBackground)
}

extension DateFormatter {
    static let allNumericIndia: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()
}

extension String {
    func dateParse() -> Date {
        guard let parsedDate = DateFormatter.allNumericIndia.date(from: self) else { return Date() }
        return parsedDate
    }
    
    func getDateFromParsedString() -> String {
        return self.components(separatedBy: " ")[0]
    }
}

extension Date {
    func formatted() -> String{
        return self.formatted(.dateTime.year().month().day())
    }
}

extension Double {
    func roundTo2Digits() -> Double {
        return (self * 100).rounded() / 100
    }
}

extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
}
