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
    
    private let textPadding: CGFloat = 16
    private let viewPadding: CGFloat = 20
    
    @Binding var isPresented: Bool
    
    init(
        _ petType: PetType = .dog,
        title: String,
        message: String,
        confirmTitle: String = "확인",
        cancelTitle: String = "취소",
        isPresented: Binding<Bool>,
        confirmAction: @escaping () -> Void,
        cancelAction: @escaping () -> Void = {}
    ) {
        self.petType = petType
        self.title = title
        self.message = message
        self.confirmTitle = confirmTitle
        self.cancelTitle = cancelTitle
        self._isPresented = isPresented
        self.confirmAction = confirmAction
        self.cancelAction = cancelAction
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }
            
            VStack {
                Spacer()
                sheetContent
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea()
        }
    }
    
    private var sheetContent: some View {
        ZStack(alignment: .top) {
            VStack {
                Spacer()
                    .frame(height: 70)
                
                bodyContent
                
                HStack(spacing: 20) {
                    PawSecondaryButton(
                        cancelTitle,
                        textPadding: textPadding,
                        horizontalPadding: 0,
                        verticalPadding: 0
                    ) {
                        isPresented = false
                        cancelAction()
                    }
                    
                    PawPrimaryButton(
                        confirmTitle,
                        textPadding: textPadding,
                        horizontalPadding: 0,
                        verticalPadding: 0
                    ) {
                        isPresented = false
                        confirmAction()
                    }
                }
                .padding(viewPadding)
            }
            .padding(.bottom, viewPadding)
            .background(.white)
            .cornerRadius(12)
            
            HeaderPetImage(type: petType)
        }.frame(height: 286)
    }
    
    private var bodyContent: some View {
        VStack(spacing: 12) {
            Text(title)
                .pretendardFont(size: ._20, weight: .semibold)
                .foregroundColor(.grayScale01)
            
            Text(message)
                .pretendardFont(size: ._14, weight: .medium)
                .foregroundColor(.grayScale02)
                .multilineTextAlignment(.center)
                .padding(.bottom, 17)
        }
        .padding(.horizontal, viewPadding)
    }
    
    // TODO: - Image Component 교체 및 파일명 처리 방안 고민
    private struct HeaderPetImage: View {
        let type: PetType
        
        var body: some View {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 170)
                .alignmentGuide(.top) { _ in 0 }
                .offset(y: -120)
        }
        private var imageName: ImageResource {
            type == .dog ? .saveDog : .saveCat
        }
    }
}

#Preview("강아지 버전") {
    PawConfirmBottomSheet(
        .dog,
        title: "포우컷 생성완료!",
        message: "포우-컷 생성이 완료되었어요.\n지금 바로 확인해보세요.",
        confirmTitle: "홈으로 가기",
        cancelTitle: "닫기",
        isPresented: .constant(true),
        confirmAction: {},
        cancelAction: {}
    )
}

#Preview("고양이 버전") {
    PawConfirmBottomSheet(
        .cat,
        title: "포우컷 생성완료!",
        message: "포우-컷 생성이 완료되었어요.\n지금 바로 확인해보세요.",
        confirmTitle: "홈으로 가기",
        cancelTitle: "닫기",
        isPresented: .constant(true),
        confirmAction: {},
        cancelAction: {}
    )
}


