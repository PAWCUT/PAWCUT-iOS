import SwiftUI

struct PawcutSelectionView: View {
    @StateObject private var viewModel = PawcutSelectionViewModel()
    
    @State private var selectedImages: [UIImage] = []

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
            PawCutGridImagePreview(images: selectedImages, style: .selection)
                .padding(.top, 38)

            // 사진 선택 카운트
            HStack(spacing: 0) {
                Text("사진 선택하기")
                    .pretendardFont(size: ._18, weight: .semibold)
                    .foregroundColor(.grayScale01)
                Text("(\(selectedImages.count)/4)")
                    .pretendardFont(size: ._18, weight: .semibold)
                    .foregroundColor(.pointPurple01)
                    .padding(.leading, 4)
                Spacer()
            }
            .padding(.top, 68)
            .padding(.horizontal, 21)

            // 선택된 사진 썸네일
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(0..<4) { index in
                        if index < selectedImages.count {
                            Image(uiImage: selectedImages[index])
                                .resizable()
                                .scaledToFill()
                                .frame(width: 64, height: 90)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                        } else {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 100, height: 132)
                        }
                    }
                }
                .padding(.top, 18)
                .padding(.horizontal)
            }

            PawSecondaryButton("다음") {
                viewModel.tapNextButton()
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    PawcutSelectionView()
}
