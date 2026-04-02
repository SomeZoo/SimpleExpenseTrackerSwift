//
//  SharePreviewView.swift
//  SimpleExpenseTrackerSwift
//

import SwiftUI
import Photos

struct SharePreviewView: View {
    let expense: Expense
    let onSave: () -> Void
    let onShare: () -> Void
    let onClose: () -> Void
    
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
                    Button(action: onSave) {
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
                    
                    Button(action: onShare) {
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
