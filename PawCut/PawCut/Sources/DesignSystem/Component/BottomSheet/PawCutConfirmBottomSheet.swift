//
//  PawCutConfirmBottomSheet.swift
//  PawCut
//
//  Created by taeni on 7/20/25.
//

import SwiftUI

struct PawConfirmBottomSheet: View {
    
    private let title: String
    private let message: String?
    private let confirmTitle: String
    private let cancelTitle: String
    private let confirmAction: () -> Void
    private let cancelAction: () -> Void
    
    @Binding var isPresented: Bool
    
    init(
        title: String,
        message: String? = nil,
        confirmTitle: String = "확인",
        cancelTitle: String = "취소",
        isPresented: Binding<Bool>,
        confirmAction: @escaping () -> Void,
        cancelAction: @escaping () -> Void = {}
    ) {
        self.title = title
        self.message = message
        self.confirmTitle = confirmTitle
        self.cancelTitle = cancelTitle
        self._isPresented = isPresented
        self.confirmAction = confirmAction
        self.cancelAction = cancelAction
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Content
            VStack(spacing: 16) {
                // Title
                Text(title)
                    .pretendardFont(size: ._20, weight: .semibold)
                    .foregroundColor(.grayScale06)
                    .multilineTextAlignment(.center)
                
                // Message (optional)
                if let message = message {
                    Text(message)
                        .pretendardFont(size: ._14, weight: .medium)
                        .foregroundColor(.grayScale01)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 32)
            .padding(.bottom, 32)
            
            // Buttons
            VStack(spacing: 12) {
                // Confirm Button
                PawPrimaryButton(
                    confirmTitle,
                    isEnabled: true,
                    textPadding: 16,
                    horizontalPadding: 0,
                    verticalPadding: 0
                ) {
                    confirmAction()
                    isPresented = false
                }
                
                // Cancel Button
                Button(action: {
                    cancelAction()
                    isPresented = false
                }) {
                    Text(cancelTitle)
                        .pretendardFont(size: ._16, weight: .medium)
                        .foregroundColor(.grayScale04)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.grayScale01)
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(.white)
        .cornerRadius(20, corners: [.topLeft, .topRight])
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
    }
}

// Custom corner radius modifier
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// Usage Example
struct PawConfirmBottomSheetExample: View {
    @State private var showConfirm = false
    
    var body: some View {
        ZStack {
            VStack {
                Button("Show Confirm") {
                    showConfirm = true
                }
                Spacer()
            }
            .padding()
            
            // Overlay
            if showConfirm {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showConfirm = false
                    }
                    .transition(.opacity)
                
                VStack {
                    Spacer()
                    PawConfirmBottomSheet(
                        title: "정말로 삭제하시겠습니까?",
                        message: "삭제된 데이터는 복구할 수 없습니다.",
                        confirmTitle: "삭제",
                        cancelTitle: "취소",
                        isPresented: $showConfirm,
                        confirmAction: {
                            // 확인 액션
                            print("Confirmed!")
                        },
                        cancelAction: {
                            // 취소 액션
                            print("Cancelled!")
                        }
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                .ignoresSafeArea()
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showConfirm)
    }
}

#Preview {
    PawConfirmBottomSheetExample()
}
