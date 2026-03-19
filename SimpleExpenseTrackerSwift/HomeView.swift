//
//  HomeView.swift
//  SimpleExpenseTrackerSwift
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Expense.date, order: .reverse) private var expenses: [Expense]
    
    @State private var showingAddExpense = false
    @State private var selectedExpense: Expense?
    @State private var expenseToEdit: Expense?
    
    let categories = ["餐饮", "交通", "购物", "娱乐", "居住", "医疗", "教育", "其他"]
    
    var totalAmountForToday: Double {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return expenses
            .filter { calendar.isDate($0.date, inSameDayAs: today) }
            .reduce(0) { $0 + $1.amount }
    }
    
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
    
    var recentExpenses: [Expense] {
        Array(expenses.prefix(20))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    summaryCard
                    expensesList
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("记账本")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddExpense = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddExpenseView()
            }
            .sheet(item: $selectedExpense) { expense in
                ExpenseDetailView(expense: expense)
            }
            .sheet(item: $expenseToEdit) { expense in
                AddExpenseView(expense: expense)
            }
        }
    }
    
    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("今日支出")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.9))
                
                Text(CurrencyFormatter.attributedAmount(
                    totalAmountForToday,
                    fontSize: 32,
                    color: .white
                ))
            }
            
            HStack(spacing: 8) {
                Text("本月支出")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.8))
                
                Text(CurrencyFormatter.attributedAmount(
                    totalAmountForThisMonth,
                    fontSize: 16,
                    color: .white
                ))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.blue)
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private var expensesList: some View {
        List {
            ForEach(recentExpenses) { expense in
                ExpenseRowView(expense: expense)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedExpense = expense
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            deleteExpense(expense)
                        } label: {
                            Label("删除", systemImage: "trash")
                        }
                        
                        Button {
                            expenseToEdit = expense
                        } label: {
                            Label("编辑", systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
            }
        }
        .listStyle(.plain)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
        .frame(height: CGFloat(recentExpenses.count) * 60)
    }
    
    private func deleteExpense(_ expense: Expense) {
        modelContext.delete(expense)
    }
}

struct ExpenseRowView: View {
    let expense: Expense
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(expense.title)
                    .font(.system(size: 16, weight: .medium))
                
                Text(formattedDate(expense.date))
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(CurrencyFormatter.attributedExpenseAmount(
                expense.amount,
                fontSize: 16,
                color: .red
            ))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd HH:mm"
        return formatter.string(from: date)
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Expense.self, inMemory: true)
}