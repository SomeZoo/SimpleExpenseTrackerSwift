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
    
    @State private var shareImage: UIImage?
    
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
                    .onAppear {
                        generateImage()
                    }
                
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
    
    private func generateImage() {
        let renderer = ImageRenderer(content: ShareCard(expense: expense).frame(width: 340, height: 460))
        renderer.scale = UIScreen.main.scale
        shareImage = renderer.uiImage
    }
}

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

// 生成图片扩展
extension View {
    func generateImage(size: CGSize) -> UIImage? {
        let renderer = ImageRenderer(content: self.frame(width: size.width, height: size.height))
        renderer.scale = UIScreen.main.scale
        return renderer.uiImage
    }
}
