import SwiftUI

struct PawcutSelectionView: View {
    @StateObject private var viewModel = PawcutSelectionViewModel()

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

            PawcutGridImagePreview(
                images: viewModel.selectedImagesInOrder,
                frameOverlay: nil,
                style: .selection
            )
            .padding(.top, 38)

            HStack(spacing: 0) {
                Text("사진 선택하기")
                    .pretendardFont(size: ._18, weight: .semibold)
                    .foregroundColor(.grayScale01)
                Text("(\(viewModel.selectedCount)/\(viewModel.maxSelection))")
                    .pretendardFont(size: ._18, weight: .semibold)
                    .foregroundColor(.pointPurple01)
                    .padding(.leading, 4)
                Spacer()
            }
            .padding(.top, 68)
            .padding(.horizontal, 21)

            SelectableImageScrollView(viewModel: viewModel)
            
            if viewModel.selectedCount == 4 {
                PawPrimaryButton("다음") {
                    viewModel.tapNextButton()
                }
            } else {
                PawSecondaryButton("다음") {
                    viewModel.tapNextButton()
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear {
            viewModel.loadSavedData()
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    PawcutSelectionView()
}
