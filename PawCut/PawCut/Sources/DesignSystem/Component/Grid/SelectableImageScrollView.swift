import SwiftUI

struct SelectableImageScrollView: View {
    @ObservedObject var viewModel: PawcutSelectionViewModel

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(0..<viewModel.sourceImagesCount, id: \.self) { index in
                    ZStack(alignment: .topLeading) {
                        Image(uiImage: viewModel.sourceImages[index])
                            .resizable()
                            .frame(width: 100, height: 132)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                            .contentShape(RoundedRectangle(cornerRadius: 4))
                            .onTapGesture {
                                viewModel.toggleSelection(at: index)
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .strokeBorder(
                                        viewModel.isSelected(index)
                                            ? Color.grayScale01 : .clear,
                                        lineWidth: 2
                                    )
                            )

                        if let order = viewModel.selectionOrder(index) {
                            Text("\(order)")
                                .pretendardFont(size: ._9, weight: .semibold)
                                .foregroundStyle(.white)
                                .frame(width: 20, height: 20)
                                .background(Color.grayScale01)
                                .clipShape(Capsule())
                                .padding(6)
                        }
                    }
                }
            }
            .padding(.top, 18)
            .padding(.horizontal)
        }
    }
}
