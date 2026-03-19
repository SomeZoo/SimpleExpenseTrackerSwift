//
//  ExpenseDetailView.swift
//  SimpleExpenseTrackerSwift
//

import SwiftUI

struct ExpenseDetailView: View {
    let expense: Expense
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    amountCard
                    infoCard
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("账单详情")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("关闭") { dismiss() }
                }
            }
        }
    }
    
    private var amountCard: some View {
        VStack {
            Text(CurrencyFormatter.attributedExpenseAmount(
                expense.amount,
                fontSize: 42,
                color: .red
            ))
            .padding(.vertical, 35)
        }
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private var infoCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            InfoRow(title: "标题", value: expense.title)
            InfoRow(title: "分类", value: expense.category ?? "-")
            InfoRow(title: "时间", value: formattedDate(expense.date))
            
            if let note = expense.note, !note.isEmpty {
                InfoRow(title: "备注", value: note)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        return formatter.string(from: date)
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .frame(width: 60, alignment: .leading)
            
            Text(value)
                .font(.system(size: 16))
                .foregroundColor(.primary)
                .lineLimit(nil)
            
            Spacer()
        }
    }
}

#Preview {
    ExpenseDetailView(expense: Expense(
        title: "午餐",
        amount: 35.50,
        date: Date(),
        category: "餐饮",
        note: "和同事一起吃饭"
    ))
}