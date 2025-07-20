//
//  PawConfirmBottomSheet.swift
//  PawCut
//
//  Created by taeni on 7/20/25.
//

import SwiftUI

struct PawConfirmBottomSheet: View {
    
    private let title: String
    private let message: String
    private let confirmTitle: String
    private let cancelTitle: String
    private let petType: PetType
    private let confirmAction: () -> Void
    private let cancelAction: () -> Void
    
    @Binding var isPresented: Bool
    
    init(
        title: String,
        message: String,
        confirmTitle: String = "확인",
        cancelTitle: String = "취소",
        petType: PetType = .dog,
        isPresented: Binding<Bool>,
        confirmAction: @escaping () -> Void,
        cancelAction: @escaping () -> Void = {}
    ) {
        self.title = title
        self.message = message
        self.confirmTitle = confirmTitle
        self.cancelTitle = cancelTitle
        self.petType = petType
        self._isPresented = isPresented
        self.confirmAction = confirmAction
        self.cancelAction = cancelAction
    }
    
    var body: some View {
        ZStack {
            backgroundOverlay
            
            VStack {
                Spacer()
                sheetContent
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea()
        }
    }
    
    private var backgroundOverlay: some View {
        Color.black.opacity(0.4)
            .ignoresSafeArea()
            .onTapGesture {
                // 빈 여백 터치 시 닫히도록 할 것인지
                isPresented = false
            }
    }
    
    private var sheetContent: some View {
        ZStack(alignment: .top) {
            modalCard
            HeaderPetImage(type: petType)
        }
    }
    
    private var modalCard: some View {
        VStack {
            characterImageSpace
            BodyContent(title: title, message: message)
            buttonSection
        }
        .padding(.bottom, 20)
        .background(Color.white)
        .cornerRadius(12)
    }
    
    private var characterImageSpace: some View {
        Spacer()
            .frame(height: 70)
    }
    
    private var buttonSection: some View {
        HStack(spacing: 20) {
            PawSecondaryButton(
                cancelTitle,
                textPadding: 16,
                horizontalPadding: 0,
                verticalPadding: 0
            ) {
                handleCancelAction()
            }
            
            PawPrimaryButton(
                confirmTitle,
                textPadding: 16,
                horizontalPadding: 0,
                verticalPadding: 0
            ) {
                handleConfirmAction()
            }
        }
        .padding(20)
    }
    
    private func handleCancelAction() {
        cancelAction()
        isPresented = false
    }
    
    private func handleConfirmAction() {
        confirmAction()
        isPresented = false
    }
}

// TODO: - Image Component 교체 및 파일명 처리 방안 고민
struct HeaderPetImage: View {
    let type: PetType
    
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: 170)
            .alignmentGuide(.top) { _ in 0 }
            .offset(y: -120)
    }
    
    private var imageName: String {
        type == .dog ? "save_dog" : "save_cat"
    }
}

struct BodyContent: View {
    let title: String
    let message: String
    
    var body: some View {
        VStack(spacing: 12) {
            titleText
            messageText
        }
        .padding(.horizontal, 20)
    }
    
    private var titleText: some View {
        Text(title)
            .pretendardFont(size: ._20, weight: .semibold)
            .foregroundColor(.black)
    }
    
    private var messageText: some View {
        Text(message)
            .pretendardFont(size: ._14, weight: .medium)
            .foregroundColor(.grayScale02)
            .multilineTextAlignment(.center)
            .lineSpacing(4)
            .padding(.bottom, 17)
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


extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

#Preview("강아지 버전") {
    PawConfirmBottomSheet(
        title: "포우컷 생성완료!",
        message: "포우-컷 생성이 완료되었어요.\n지금 바로 확인해보세요.",
        confirmTitle: "홈으로 가기",
        cancelTitle: "닫기",
        petType: .dog,
        isPresented: .constant(true),
        confirmAction: {},
        cancelAction: {}
    )
}

#Preview("고양이 버전") {
    PawConfirmBottomSheet(
        title: "포우컷 생성완료!",
        message: "포우-컷 생성이 완료되었어요.\n지금 바로 확인해보세요.",
        confirmTitle: "홈으로 가기",
        cancelTitle: "닫기",
        petType: .cat,
        isPresented: .constant(true),
        confirmAction: {},
        cancelAction: {}
    )
}
