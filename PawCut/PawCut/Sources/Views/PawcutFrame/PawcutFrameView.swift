import SwiftUI

struct PawcutFrameView: View {
    @State private var selectedImages: [UIImage] = []
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.grayScale01)
                }
                .frame(width: 33, height: 44)

                Spacer()
            }

            // 상단 이미지 프레임 미리보기
            GridImagePreview(images: selectedImages, style: .frame)
                .padding(.top, 38)

            // 사진 선택 카운트
            HStack(spacing: 0) {
                Text("\(selectedImages.count)White")
                    .pretendardFont(size: ._18, weight: .bold)
                    .foregroundColor(.grayScale01)
                
            }
            .padding(.top, 48)
            .padding(.horizontal, 21)

            // 선택된 사진 썸네일
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(0..<10) { index in
                        if index < selectedImages.count {
                            Image(uiImage: selectedImages[index])
                                .resizable()
                                .scaledToFill()
                                .frame(width: 64, height: 90)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
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
                // 다음 단계로 이동
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    PawcutFrameView()
}

