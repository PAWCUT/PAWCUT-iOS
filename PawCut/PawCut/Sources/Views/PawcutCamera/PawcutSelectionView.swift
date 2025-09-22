//
//  PawcutCamera.swift
//  PawCut
//
//  Created by 해피제이 on 8/12/25.
//

import SwiftUI

struct PawcutSelectionView: View {
    @StateObject var viewModel: PawcutSelectionViewModel

    init(images: [UIImage]) {
        self._viewModel = StateObject(
            wrappedValue: PawcutSelectionViewModel(sourceImages: images)
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            PawBackButtonNavigationBar {
                viewModel.requestBackNavigation()
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

            PawcutSelectionHeaderView(
                selectedCount: viewModel.selectedCount,
                maxSelection: viewModel.maxSelection
            )

            SelectableImageScrollView(
                images: viewModel.sourceImages,
                selectedIndices: viewModel.selectedIndices,
                selectionOrder: { viewModel.selectionOrder($0) },
                onToggleSelection: { viewModel.toggleSelection(at: $0) }
            )

            PawPrimaryButton("다음", isEnabled: viewModel.selectedCount == 4) {
                viewModel.tapNextButton()
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .navigationBarBackButtonHidden()
        .pawAlert(
            isShowing: $viewModel.showBackAlert,
            title: "이전 화면으로 돌아가시겠어요?",
            message: "선택 중인 사진이 사라질 수 있어요.",
            confirmTitle: "돌아가기",
            cancelTitle: "취소",
            onConfirm: {
                viewModel.confirmBackNavigation()
            }
        )
    }
}

#Preview {
    PawcutSelectionView(images: [UIImage(named: "onboarding_1")!])
}
