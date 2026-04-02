//
//  SharePreviewView.swift
//  SimpleExpenseTrackerSwift
//

import SwiftUI
import Photos

struct SharePreviewView: View {
    let expense: Expense
    let onClose: () -> Void
    
    @State private var shareImage: UIImage? = nil
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            // 毛玻璃背景
            VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
                .ignoresSafeArea()
                .onTapGesture {
                    onClose()
                }
            
            VStack(spacing: 20) {
                // 分享卡片
                ShareCard(expense: expense)
                    .frame(width: 340, height: 460)
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                
                // 按钮
                VStack(spacing: 12) {
                    Button(action: saveToAlbum) {
                        HStack {
                            Text("📷")
                            Text("保存到相册")
                        }
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(25)
                    }
                    
                    Button(action: shareImageAction) {
                        HStack {
                            Text("📤")
                            Text("分享")
                        }
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.green)
                        .cornerRadius(25)
                    }
                }
            }
            
            // 关闭按钮
            VStack {
                HStack {
                    Spacer()
                    Button(action: onClose) {
                        Text("✕")
                            .font(.system(size: 24, weight: .light))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                    }
                }
                Spacer()
            }
            .padding(.top, 60)
            .padding(.trailing, 16)
        }
        .onAppear {
            // 预生成图片
            generateImage()
        }
        .alert(alertTitle, isPresented: $showAlert) {
            Button("确定", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
    }
    
    private func generateImage() {
        DispatchQueue.global(qos: .userInitiated).async {
            let card = ShareCard(expense: expense)
                .frame(width: 340, height: 460)
            let renderer = ImageRenderer(content: card)
            renderer.scale = UIScreen.main.scale
            let image = renderer.uiImage
            DispatchQueue.main.async {
                self.shareImage = image
            }
        }
    }
    
    private func saveToAlbum() {
        guard let image = shareImage else {
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
    
    private func shareImageAction() {
        guard let image = shareImage else {
            showAlert(title: "生成失败", message: "无法生成分享图片")
            return
        }
        
        // 使用 UIKit 直接 present，不通过 SwiftUI sheet
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityVC.excludedActivityTypes = [.assignToContact, .addToReadingList]
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            // 找到最顶层的 view controller
            var topVC = rootVC
            while let presented = topVC.presentedViewController {
                topVC = presented
            }
            // 如果当前有 presented VC（即我们的 fullScreenCover），在它上面再 present
            topVC.present(activityVC, animated: true)
        }
    }
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}

// UIKit 毛玻璃效果包装
struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView()
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = effect
    }
}
