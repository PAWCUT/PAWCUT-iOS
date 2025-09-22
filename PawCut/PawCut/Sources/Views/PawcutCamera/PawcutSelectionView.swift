//
//  PawcutCamera.swift
//  PawCut
//
//  Created by 해피제이 on 8/12/25.
//

import SwiftUI

struct PawcutSelectionView: View {
    @StateObject var viewModel: PawcutSelectionViewModel
    @State private var showBackAlert = false

    init(images: [UIImage]) {
        self._viewModel = StateObject(
            wrappedValue: PawcutSelectionViewModel(sourceImages: images)
        )
    }

    var body: some View {
        ZStack {
            // TODO: 컴포넌트 분리
            VStack(spacing: 0) {
                // TODO: 로직 분리
                PawBackButtonNavigationBar {
                    showBackAlert = true
                }

                Spacer()

                ScrollView {
                    PawcutGridImagePreview(
                        images: viewModel.selectedImagesInOrder,
                        frameOverlay: nil,
                        style: .selection
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.top, 38)
                }

                Spacer()

                // TODO: 라벨 컴포넌트 쓰세요
                HStack(spacing: 0) {
                    PawTitleLabel.semi18("사진 선택하기")
                    PawTitleLabel.semi18(
                        "(\(viewModel.selectedCount)/\(viewModel.maxSelection))",
                        color: .pointPurple01
                    )
                    .padding(.leading, 4)

                    Spacer()
                }

                .padding(.horizontal, 21)

                // TODO: VIewModel 넘기지 말아
                SelectableImageScrollView(viewModel: viewModel)

                PawPrimaryButton("다음", isEnabled: viewModel.selectedCount == 4)
                {
                    viewModel.tapNextButton()
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .navigationBarBackButtonHidden()
        }
        .pawAlert(
            isShowing: $showBackAlert,
            title: "이전 화면으로 돌아가시겠어요?",
            message: "선택 중인 사진이 사라질 수 있어요.",
            confirmTitle: "돌아가기",
            cancelTitle: "취소",
            onConfirm: {
                viewModel.tapBackButton()
            }
        )
    }
}

#Preview {
    PawcutSelectionView(images: [UIImage(named: "onboarding_1")!])
}
