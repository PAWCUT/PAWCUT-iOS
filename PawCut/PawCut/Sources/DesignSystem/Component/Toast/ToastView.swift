//
//  PawCutToast.swift
//  pawCut
//
//  Created by taeni on 6/4/25.
//

import SwiftUI

// TODO : iconName 초기값 지정
struct ToastView: View {
    let message: String
    var iconName: String
    var backgroundColor: Color = .grayScale01
    var textColor: Color = .white
    var iconColor: Color = .pointPurple01
    var cornerRadius: CGFloat = 20
    
    var body: some View {
        HStack(spacing: 12) {
            ImageComponent(imageName: iconName, size: CGSize(width: 16, height: 16))
            PawTitleLabel.semi14(message, color: textColor)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .shadow(radius: 8)
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
    }
}

struct ToastModifier: ViewModifier {
    @Binding var isShowing: Bool
    let message: String
    let iconName: String
    var duration: TimeInterval = 3.0 // 토스트가 표시되는 시간
    var animation: Animation = .easeInOut(duration: 0.3)
    var transition: AnyTransition = .move(edge: .bottom).combined(with: .opacity)
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content // 원래의 뷰 내용
            
            if isShowing {
                ToastView(message: message, iconName: iconName)
                    .transition(transition)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                            withAnimation(animation) {
                                isShowing = false
                            }
                        }
                    }
                    .padding(.bottom, 62)
            }
        }
    }
}

extension View {
    func toast(isShowing: Binding<Bool>, message: String, iconName: String, duration: TimeInterval = 2.0) -> some View {
        self.modifier(ToastModifier(isShowing: isShowing, message: message, iconName: iconName, duration: duration))
    }
}

struct ToastTestView: View {
    @State private var showSuccessToast: Bool = false
    @State private var showFailToast: Bool = false
    @State private var showLongMessageToast: Bool = false
    @State private var showDelayedToast: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()
                
                Button("성공 토스트 표시 (2초)") {
                    showSuccessToast = true
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                
                Button("실패 토스트 표시 (3초)") {
                    showFailToast = true
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                
                Button("긴 메시지 토스트 표시 (4초)") {
                    showLongMessageToast = true
                }
                .buttonStyle(.bordered)
                
                Button("지연된 토스트 표시 (1초 후 2초 지속)") {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        showDelayedToast = true
                    }
                }
                .buttonStyle(.bordered)
                
                Spacer()
            }
            .navigationTitle("토스트 테스트")
            .navigationBarTitleDisplayMode(.inline)
            .toast(isShowing: $showSuccessToast, message: "작업이 성공적으로 처리되었습니다!", iconName: "toast_icon", duration: 2.0)
            .toast(isShowing: $showFailToast, message: "오류가 발생했습니다. 다시 시도해주세요.", iconName: "toast_icon", duration: 3.0)
            .toast(isShowing: $showLongMessageToast, message: "이것은 매우 긴 메시지를 담고 있는 토스트입니다. \n여러 줄로 표시될 수 있습니다.\n이렇게\n이렇게", iconName: "toast_icon", duration: 4.0)
            .toast(isShowing: $showDelayedToast, message: "1초 후 나타난 토스트입니다.", iconName: "toast_icon", duration: 2.0)
        }
    }
}

#Preview {
    ToastTestView()
}

