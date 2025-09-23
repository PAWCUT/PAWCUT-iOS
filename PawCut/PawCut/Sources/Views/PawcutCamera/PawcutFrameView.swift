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

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(
                            // TODO: 왜 Array 써야하지?
                            Array(viewModel.frameScrollImageNames.enumerated()),
                            id: \.offset
                        ) { index, name in

                            let image = UIImage(named: name)
                            let isSelected =
                                index == viewModel.selectedFrameIndex

                            if let image = image {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .strokeBorder(
                                                isSelected
                                                    ? Color.pointPurple01
                                                    : .clear,
                                                lineWidth: 2
                                            )
                                    )
                                    .onTapGesture {
                                        viewModel.selectedFrameIndex = index
                                    }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 31)
                .padding(.leading, 4)

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
                    // TODO: 로직 분리
                    if viewModel.selectedFrameIndex == nil {
                        viewModel.selectedFrameIndex = 0
                    }
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
    }
}

#Preview {
    PawcutFrameView(images: [])
}
