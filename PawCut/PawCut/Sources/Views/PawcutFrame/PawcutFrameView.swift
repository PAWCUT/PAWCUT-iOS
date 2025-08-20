import SwiftUI

struct PawcutFrameView: View {
    @StateObject private var viewModel = PawcutFrameViewModel()

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    viewModel.tapBackButton()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.grayScale01)
                }
                .frame(width: 33, height: 44)

                Spacer()
            }

            // 상단 이미지 프레임 미리보기
            PawCutGridImagePreview(
                images: viewModel.selectedImages,
                style: .frame
            )
            .padding(.top, 38)

            // 선택된 프레임 이름
            HStack(spacing: 0) {
                Text(viewModel.selectedFrameDisplayName ?? "")
                    .pretendardFont(size: ._18, weight: .bold)
                    .foregroundColor(.grayScale01)

            }
            .padding(.top, 48)
            .padding(.horizontal, 21)

            // 선택된 프레임 썸네일
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(
                        Array(viewModel.frameScrollImageNames.enumerated()),
                        id: \.offset
                    ) { index, name in

                        let image = UIImage(named: name)
                        let isSelected = index == viewModel.selectedFrameIndex

                        if let image = image {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .strokeBorder(
                                            isSelected
                                                ? Color.pointPurple01 : .clear,
                                            lineWidth: 2
                                        )
                                )
                                .onTapGesture {
                                    viewModel.selectedFrameIndex = index
                                }
                        }
                    }
                }
                .padding(.top, 38)
                .padding(.horizontal)
            }
            .padding(.leading, 4)

            PawSecondaryButton("저장하기") {
                viewModel.isBottomSheetPresented = true
            }
        }
        .onAppear {
            if viewModel.selectedFrameIndex == nil {
                viewModel.selectedFrameIndex = 0
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .overlay(
            Group {
                if viewModel.isBottomSheetPresented {
                    PawConfirmBottomSheet(
                        .dog,
                        title: "포우컷 생성완료!",
                        message: "포우-컷 생성이 완료되었어요.\n지금 바로 확인해보세요.",
                        confirmTitle: "홈으로 가기",
                        cancelTitle: "닫기",
                        isPresented: $viewModel.isBottomSheetPresented,
                        // TODO: 확인
                        confirmAction: {
                        },
                        // TODO: 취소
                        cancelAction: {
                        }
                    )
                }
            }
        )
    }
}

#Preview {
    PawcutFrameView()
}
