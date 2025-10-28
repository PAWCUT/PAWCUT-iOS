//
//  PawcutCamera.swift
//  PawCut
//
//  Created by 해피제이 on 8/12/25.
//

import SwiftUI

struct PawcutFrameView: View {
    @StateObject private var viewModel: PawcutFrameViewModel
    @Environment(\.modelContext) var modelContext

    init(images: [UIImage]) {
        self._viewModel = StateObject(
            wrappedValue: PawcutFrameViewModel(selectedImages: images)
        )
    }

    var body: some View {
        ZStack {
            // TODO: 컴포넌트 분리
            VStack(spacing: 0) {
                ScrollView {
                    PawcutGridImagePreview(
                        images: viewModel.selectedImages,
                        frameOverlay: viewModel.selectedFrameImage,
                        style: .frame
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.top, 42)
                }

                Spacer()

                PawTitleLabel.bold18(viewModel.selectedFrameDisplayName ?? "")
                    .padding(.horizontal, 21)

                PawcutFrameSelectionScrollView(
                    frames: viewModel.frames,
                    selectedFrameIndex: viewModel.selectedFrameIndex,
                    onSelect: { index in
                        viewModel.selectedFrameIndex = index
                    }
                )

                PawPrimaryButton("저장하기") {
                    let exportView = PawcutGridImagePreview(
                        images: viewModel.selectedImages,
                        frameOverlay: viewModel.selectedFrameImage,
                        style: .frame
                    )

                    let renderer = ImageRenderer(content: exportView)
                    renderer.scale = UIScreen.main.scale

                    if let uiImage = renderer.uiImage {
                        // TODO: SwiftData 저장
                        Task {
                            let fileName = try await ImageFileManager.shared
                                .saveImage(uiImage)

                            let photo = Photo(fileName: fileName)
                            modelContext.insert(photo)
                            try! modelContext.save()

                            viewModel.isBottomSheetPresented = true
                        }
                    }
                }
                .onAppear {
                    viewModel.selectDefaultFrameIfNeeded()
                }
            }

            if viewModel.isBottomSheetPresented {
                PawConfirmBottomSheet(
                    .dog,
                    title: "포우컷 생성완료!",
                    message: "포우-컷 생성이 완료되었어요.\n지금 바로 확인해보세요.",
                    confirmTitle: "홈으로 가기",
                    cancelTitle: "닫기",
                    isPresented: $viewModel.isBottomSheetPresented,
                    confirmAction: {
                        viewModel.tapHomeButton()
                    },
                    cancelAction: {
                        viewModel.tapCancelButton()
                    }
                )
            }
        }
        .pawNavigationBar()
        .enableNativeSwipeBack(true)
    }
}

#Preview {
    PawcutFrameView(images: [])
}
