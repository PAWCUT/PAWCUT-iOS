//
//  PawAlertView.swift
//  PawCut
//
//  Created by Assistant on 8/18/25.
//

import SwiftUI

struct PawAlertView: View {
    let title: String
    let message: String
    let confirmTitle: String
    let cancelTitle: String
    let onConfirm: () -> Void
    let onCancel: () -> Void
    
    init(
        title: String,
        message: String,
        confirmTitle: String = "확인",
        cancelTitle: String = "취소",
        onConfirm: @escaping () -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.title = title
        self.message = message
        self.confirmTitle = confirmTitle
        self.cancelTitle = cancelTitle
        self.onConfirm = onConfirm
        self.onCancel = onCancel
    }
    
    var body: some View {
        VStack(spacing: 22) {
            VStack(spacing: 8) {
                PawTitleLabel.semi16(
                    title,
                    color: .grayScale01
                )
                
                PawBodyLabel.med14(
                    message,
                    color: .grayScale02,
                    alignment: TextAlignment.center
                )
            }
            
            HStack(spacing: 12) {
                Button(action: onCancel) {
                    PawButtonLabel.semi16(cancelTitle, color: .grayScale03)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                        .background(.grayScale05)
                        .cornerRadius(8)
                }
                
                Button(action: onConfirm) {
                    PawButtonLabel.semi16(confirmTitle, color: .grayScale06)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                        .background(.pointPurple01)
                        .cornerRadius(8)
                }
            }
        }
        .padding(.top, 22)
        .padding(.bottom, 18)
        .padding(.horizontal, 20)
        .background(.white)
        .cornerRadius(8)
        .padding(.horizontal, 20)
    }
}

struct PawAlertModifier: ViewModifier {
    @Binding var isShowing: Bool
    let title: String
    let message: String
    let confirmTitle: String
    let cancelTitle: String
    let onConfirm: () -> Void
    let onCancel: (() -> Void)?
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isShowing {
                Color.black.opacity(0.6)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isShowing = false
                        }
                    }
                
                PawAlertView(
                    title: title,
                    message: message,
                    confirmTitle: confirmTitle,
                    cancelTitle: cancelTitle,
                    onConfirm: {
                        onConfirm()
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isShowing = false
                        }
                    },
                    onCancel: {
                        onCancel?() ?? nil
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isShowing = false
                        }
                    }
                )
                .transition(.scale(scale: 0.95).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.1), value: isShowing)
    }
}

extension View {
    func pawAlert(
        isShowing: Binding<Bool>,
        title: String,
        message: String,
        confirmTitle: String = "확인",
        cancelTitle: String = "취소",
        onConfirm: @escaping () -> Void,
        onCancel: (() -> Void)? = nil
    ) -> some View {
        self.modifier(PawAlertModifier(
            isShowing: isShowing,
            title: title,
            message: message,
            confirmTitle: confirmTitle,
            cancelTitle: cancelTitle,
            onConfirm: onConfirm,
            onCancel: onCancel
        ))
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var showAlert = false
        @State private var showDeleteAlert = false
        
        var body: some View {
            VStack(spacing: 20) {
                Button("알림 표시") {
                    showAlert = true
                }
            }
            .pawAlert(
                isShowing: $showAlert,
                title: "저장하시겠습니까?",
                message: "변경사항이 저장됩니다.",
                confirmTitle: "저장",
                onConfirm: {
                    print("저장 확인")
                }
            )
        }
    }
    
    return PreviewWrapper()
}
