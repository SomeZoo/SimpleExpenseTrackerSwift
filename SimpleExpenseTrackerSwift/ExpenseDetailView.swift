//
//  ExpenseDetailView.swift
//  SimpleExpenseTrackerSwift
//

import SwiftUI
import Photos

struct ExpenseDetailView: View {
    let expense: Expense
    @Environment(\.dismiss) private var dismiss
    @State private var showSharePreview = false
    @State private var shareImage: UIImage?
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
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
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showSharePreview = true }) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
            .fullScreenCover(isPresented: $showSharePreview) {
                sharePreviewOverlay
            }
            .alert(alertTitle, isPresented: $showAlert) {
                Button("确定", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private var sharePreviewOverlay: some View {
        SharePreviewView(
            expense: expense,
            onSave: { saveToAlbum() },
            onShare: { shareImage() },
            onClose: { showSharePreview = false }
        )
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
    
    // MARK: - Share Actions
    
    private func generateShareImage() -> UIImage? {
        let card = ShareCard(expense: expense)
            .frame(width: 340, height: 460)
        let renderer = ImageRenderer(content: card)
        renderer.scale = UIScreen.main.scale
        return renderer.uiImage
    }
    
    private func saveToAlbum() {
        guard let image = generateShareImage() else {
            showAlert(title: "生成失败", message: "无法生成分享图片")
            return
        }
        
        let status = PHPhotoLibrary.authorizationStatus()
        
        let saveAction = {
            PHPhotoLibrary.shared().performChanges({
                let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                request.creationDate = Date()
            }) { success, error in
                DispatchQueue.main.async {
                    if success {
                        showAlert(title: "保存成功", message: "账单图片已保存到相册")
                    } else {
                        showAlert(title: "保存失败", message: error?.localizedDescription ?? "未知错误")
                    }
                }
            }
        }
        
        switch status {
        case .authorized:
            saveAction()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                DispatchQueue.main.async {
                    if newStatus == .authorized {
                        saveAction()
                    } else {
                        showAlert(title: "无法保存", message: "请在设置中允许访问相册权限")
                    }
                }
            }
        default:
            showAlert(title: "无法保存", message: "请在设置中允许访问相册权限")
        }
    }
    
    private func shareImage() {
        guard let image = generateShareImage() else {
            showAlert(title: "生成失败", message: "无法生成分享图片")
            return
        }
        
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityVC.excludedActivityTypes = [.assignToContact, .addToReadingList]
        
        // 获取当前窗口场景
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
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
