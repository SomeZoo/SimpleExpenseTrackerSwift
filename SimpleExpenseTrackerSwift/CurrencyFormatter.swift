//
//  CurrencyFormatter.swift
//  SimpleExpenseTrackerSwift
//

import Foundation
import SwiftUI

struct CurrencyFormatter {
    
    static func dinFont(size: CGFloat) -> Font {
        if let uiFont = UIFont(name: "DINAlternate-Bold", size: size) {
            return Font(uiFont)
        }
        if let uiFont = UIFont(name: "DINCondensed-Bold", size: size) {
            return Font(uiFont)
        }
        return Font.system(size: size, weight: .bold, design: .default).monospacedDigit()
    }
    
    static func normalFont(size: CGFloat, weight: Font.Weight = .medium) -> Font {
        return Font.system(size: size, weight: weight)
    }
    
    static func formattedAmount(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        return formatter.string(from: NSNumber(value: amount)) ?? String(format: "%.2f", amount)
    }
    
    static func formattedAmountWithSymbol(_ amount: Double) -> String {
        "¥\(formattedAmount(amount))"
    }
    
    static func formattedExpenseAmount(_ amount: Double) -> String {
        "-¥\(formattedAmount(amount))"
    }
    
    static func attributedAmount(_ amount: Double, fontSize: CGFloat, color: Color) -> AttributedString {
        let symbol = "¥"
        let numberText = formattedAmount(amount)
        let fullText = "\(symbol)\(numberText)"
        
        var attributed = AttributedString(fullText)
        
        if let symbolRange = attributed.range(of: symbol) {
            attributed[symbolRange].font = normalFont(size: fontSize)
            attributed[symbolRange].foregroundColor = color
        }
        
        if let numberRange = attributed.range(of: numberText) {
            attributed[numberRange].font = dinFont(size: fontSize)
            attributed[numberRange].foregroundColor = color
        }
        
        return attributed
    }
    
    static func attributedExpenseAmount(_ amount: Double, fontSize: CGFloat, color: Color) -> AttributedString {
        let prefix = "-¥"
        let numberText = formattedAmount(amount)
        let fullText = "\(prefix)\(numberText)"
        
        var attributed = AttributedString(fullText)
        
        if let prefixRange = attributed.range(of: prefix) {
            attributed[prefixRange].font = normalFont(size: fontSize)
            attributed[prefixRange].foregroundColor = color
        }
        
        if let numberRange = attributed.range(of: numberText) {
            attributed[numberRange].font = dinFont(size: fontSize)
            attributed[numberRange].foregroundColor = color
        }
        
        return attributed
    }
}