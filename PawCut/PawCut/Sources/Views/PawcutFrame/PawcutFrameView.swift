import SwiftUI

struct PawcutFrameView: View {
    @StateObject private var viewModel = PawcutFrameViewModel()
    
    @State private var selectedImages: [UIImage] = []
    @State private var selectedFrame: [UIImage] = []
    @State private var isBottomSheetPresented = false

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
            PawCutGridImagePreview(images: selectedImages, style: .frame)
                .padding(.top, 38)

            // 선택된 프레임 이름
            HStack(spacing: 0) {
                Text("\(selectedFrame.count)White")
                    .pretendardFont(size: ._18, weight: .bold)
                    .foregroundColor(.grayScale01)

            }
            .padding(.top, 48)
            .padding(.horizontal, 21)

            // 선택된 프레임 썸네일
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(0..<10) { index in
                        if index < selectedFrame.count {
                            Image(uiImage: selectedFrame[index])
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        } else {
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 40, height: 40)
                        }
                    }
                }
                .padding(.top, 38)
                .padding(.horizontal)
            }
            .padding(.leading, 4)

            PawSecondaryButton("저장하기") {
                isBottomSheetPresented = true
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .overlay(
            Group {
                if isBottomSheetPresented {
                    PawConfirmBottomSheet(
                        .dog,
                        title: "포우컷 생성완료!",
                        message: "포우-컷 생성이 완료되었어요.\n지금 바로 확인해보세요.",
                        confirmTitle: "홈으로 가기",
                        cancelTitle: "닫기",
                        isPresented: $isBottomSheetPresented,
                        confirmAction: {
                            print("✅ 홈으로 이동")
                        },
                        cancelAction: {
                            print("❌ 닫기")
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
