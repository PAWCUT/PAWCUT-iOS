import SwiftUI

struct SelectableImageScrollView: View {
    let images: [UIImage]
    let selectedIndices: [Int]
    let selectionOrder: (Int) -> Int?
    let onToggleSelection: (Int) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(images.indices, id: \.self) { index in
                    ZStack(alignment: .topLeading) {
                        Image(uiImage: images[index])
                            .resizable()
                            .frame(width: 100, height: 132)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                            .contentShape(RoundedRectangle(cornerRadius: 4))
                            .onTapGesture {
                                onToggleSelection(index)
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .strokeBorder(
                                        selectedIndices.contains(index)
                                            ? Color.grayScale01 : .clear,
                                        lineWidth: 2
                                    )
                            )

                        if let order = selectionOrder(index) {
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
