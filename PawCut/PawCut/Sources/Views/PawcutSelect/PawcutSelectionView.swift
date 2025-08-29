import SwiftUI

struct PawcutSelectionView: View {
    @StateObject var viewModel: PawcutSelectionViewModel
    @State private var showBackAlert = false
    
    init(images: [UIImage]) {
        self._viewModel = StateObject(wrappedValue: PawcutSelectionViewModel(sourceImages: images))
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        showBackAlert = true
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.grayScale01)
                    }
                    .frame(width: 33, height: 44)

                    Spacer()
                }
                
                Spacer()

                PawcutGridImagePreview(
                    images: viewModel.selectedImagesInOrder,
                    frameOverlay: nil,
                    style: .selection
                )
                
                Spacer()

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

                .padding(.horizontal, 21)

                SelectableImageScrollView(viewModel: viewModel)
                
                PawPrimaryButton("다음", isEnabled: viewModel.selectedCount == 4) {
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
