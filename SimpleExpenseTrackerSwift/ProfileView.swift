//
//  ProfileView.swift
//  SimpleExpenseTrackerSwift
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    @Query(sort: \Expense.date, order: .reverse) private var expenses: [Expense]
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    let menuItems = [
        (title: "账单统计", icon: "📊"),
        (title: "分类管理", icon: "🏷️"),
        (title: "数据导出", icon: "📤"),
        (title: "设置", icon: "⚙️")
    ]
    
    var totalAmountForThisMonth: Double {
        let calendar = Calendar.current
        let now = Date()
        return expenses
            .filter {
                calendar.component(.year, from: $0.date) == calendar.component(.year, from: now) &&
                calendar.component(.month, from: $0.date) == calendar.component(.month, from: now)
            }
            .reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        NavigationStack {
            List {
                // Header Section
                Section {
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 80, height: 80)
                            
                            Text("👤")
                                .font(.system(size: 40))
                        }
                        
                        Text("记账达人")
                            .font(.system(size: 20, weight: .semibold))
                        
                        Text("记录每一笔，理财更轻松 ✨")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                }
                .listRowBackground(Color(.systemBackground))
                
                // Stats Section
                Section {
                    HStack {
                        Spacer()
                        
                        StatItem(
                            title: "本月支出",
                            value: CurrencyFormatter.formattedAmountWithSymbol(totalAmountForThisMonth),
                            color: .red
                        )
                        
                        Spacer()
                        
                        Divider()
                        
                        Spacer()
                        
                        StatItem(
                            title: "记账天数",
                            value: "12",
                            color: .blue
                        )
                        
                        Spacer()
                        
                        Divider()
                        
                        Spacer()
                        
                        StatItem(
                            title: "总笔数",
                            value: "\(expenses.count)",
                            color: .green
                        )
                        
                        Spacer()
                    }
                    .padding(.vertical, 10)
                }
                .listRowBackground(Color(.systemBackground))
                
                // Menu Section
                Section {
                    ForEach(menuItems, id: \.title) { item in
                        Button {
                            alertMessage = "\(item.title)功能即将上线，敬请期待！"
                            showingAlert = true
                        } label: {
                            HStack {
                                Text("\(item.icon)  \(item.title)")
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                            }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("我的")
            .alert("提示", isPresented: $showingAlert) {
                Button("确定", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
}

struct StatItem: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(color)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
    }
}

#Preview {
    ProfileView()
        .modelContainer(for: Expense.self, inMemory: true)
}
