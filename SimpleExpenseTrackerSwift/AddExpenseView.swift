//
//  AddExpenseView.swift
//  SimpleExpenseTrackerSwift
//

import SwiftUI
import SwiftData

struct AddExpenseView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var expense: Expense?
    
    @State private var title = ""
    @State private var amount = ""
    @State private var category = "餐饮"
    @State private var date = Date()
    @State private var note = ""
    
    let categories = ["餐饮", "交通", "购物", "娱乐", "居住", "医疗", "教育", "其他"]
    
    var isEditing: Bool { expense != nil }
    
    var isValid: Bool {
        !title.isEmpty && (Double(amount) ?? 0) > 0
    }
    
    init(expense: Expense? = nil) {
        self.expense = expense
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        TextField("0.00", text: $amount)
                            .keyboardType(.decimalPad)
                            .font(CurrencyFormatter.dinFont(size: 48))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    .padding(.vertical, 20)
                    .listRowBackground(Color.blue)
                    .listRowInsets(EdgeInsets())
                }
                
                Section {
                    TextField("标题（如：午餐）", text: $title)
                    
                    Picker("分类", selection: $category) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    
                    DatePicker("时间", selection: $date)
                }
                
                Section(header: Text("备注")) {
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $note)
                            .frame(minHeight: 80)
                        
                        if note.isEmpty {
                            Text("备注（最多50字）")
                                .foregroundColor(.secondary)
                                .padding(.top, 8)
                                .padding(.leading, 4)
                        }
                    }
                    
                    HStack {
                        Spacer()
                        Text("\(note.count)/50")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle(isEditing ? "编辑记账" : "记一笔")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") { saveExpense() }
                        .disabled(!isValid)
                }
            }
            .onAppear {
                if let expense = expense {
                    title = expense.title
                    amount = CurrencyFormatter.formattedAmount(expense.amount)
                    category = expense.category ?? categories[0]
                    date = expense.date
                    note = expense.note ?? ""
                }
            }
        }
    }
    
    private func saveExpense() {
        guard let amountValue = Double(amount.replacingOccurrences(of: ",", with: "")), amountValue > 0 else { return }
        
        if let expense = expense {
            expense.title = title
            expense.amount = amountValue
            expense.date = date
            expense.category = category
            expense.note = note.isEmpty ? nil : note
        } else {
            let newExpense = Expense(
                title: title,
                amount: amountValue,
                date: date,
                category: category,
                note: note.isEmpty ? nil : note
            )
            modelContext.insert(newExpense)
        }
        
        dismiss()
    }
}

#Preview {
    AddExpenseView()
        .modelContainer(for: Expense.self, inMemory: true)
}