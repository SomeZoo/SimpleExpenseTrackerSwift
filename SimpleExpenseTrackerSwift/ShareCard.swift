//
//  ShareCard.swift
//  SimpleExpenseTrackerSwift
//

import SwiftUI

// 分享卡片
struct ShareCard: View {
    let expense: Expense
    
    var body: some View {
        VStack(spacing: 0) {
            // 顶部装饰条
            Rectangle()
                .fill(Color.red)
                .frame(height: 6)
            
            VStack(spacing: 16) {
                // 金额
                Text(CurrencyFormatter.attributedExpenseAmount(
                    expense.amount,
                    fontSize: 44,
                    color: .red
                ))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .padding(.top, 20)
                
                // 分隔线
                Rectangle()
                    .fill(Color(.separator))
                    .frame(height: 1)
                    .padding(.horizontal, 24)
                
                // 信息
                VStack(alignment: .leading, spacing: 12) {
                    ShareInfoRow(title: "标题", value: expense.title)
                    ShareInfoRow(title: "分类", value: expense.category ?? "-")
                    ShareInfoRow(title: "时间", value: formattedDate(expense.date))
                    
                    if let note = expense.note, !note.isEmpty {
                        ShareInfoRow(title: "备注", value: note)
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                // 底部品牌
                ZStack {
                    Rectangle()
                        .fill(Color(.init(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)))
                        .frame(height: 50)
                    
                    Text("来自 简单记账")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
            }
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        return formatter.string(from: date)
    }
}

struct ShareInfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .frame(width: 70, alignment: .leading)
            
            Text(value)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.primary)
                .lineLimit(nil)
            
            Spacer()
        }
    }
}
