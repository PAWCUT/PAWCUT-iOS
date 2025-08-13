import SwiftUI


enum GridImagePreviewStyle {
    case selection
    case frame

    var metrics: (
        imagesWidth: CGFloat,
        imagesHeight: CGFloat,
        frameWidth: CGFloat,
        frameHeight: CGFloat,
        logoHeight: CGFloat,
        logoTopPadding: CGFloat
    ) {
        switch self {
        case .selection:
            return (
                imagesWidth: 100,
                imagesHeight: 134,
                frameWidth: 225,
                frameHeight: 340,
                logoHeight: 20,
                logoTopPadding: 12
            )
        case .frame:
            return (
                imagesWidth: 130,
                imagesHeight: 174,
                frameWidth: 285,
                frameHeight: 440,
                logoHeight: 25,
                logoTopPadding: 24
            )
        }
    }
}

struct PawCutGridImagePreview: View {
    let images: [UIImage]
    let style: GridImagePreviewStyle
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<2) { row in
                if row == 1 {
                    Spacer().frame(height: 8)
                }

                HStack(spacing: 0) {
                    ForEach(0..<2) { col in
                        if col == 1 {
                            Spacer().frame(width: 5)
                        }

                        let index = row * 2 + col
                        if index < images.count {
                            Image(uiImage: images[index])
                                .resizable()
                                .scaledToFill()
                                .frame(width: style.metrics.frameWidth, height: style.metrics.frameHeight)
                                .clipped()
                        } else {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: style.metrics.imagesWidth, height: style.metrics.imagesHeight)
                                .overlay(
                                    Rectangle()
                                        .stroke(Color("GrayScale01"), lineWidth: 1)
                                )
                        }
                    }
                }
            }

            Image(.logoBlack)
                .resizable()
                .scaledToFit()
                .frame(height: style.metrics.logoHeight)
                .padding(.top, style.metrics.logoTopPadding)
            
            Spacer()
        }
        .padding(.top, 10)
        .frame(width: style.metrics.frameWidth, height: style.metrics.frameHeight)
        .overlay(
            Rectangle()
                .stroke(Color("GrayScale01"), lineWidth: 1)
        )
    }
}

#Preview {
    PawCutGridImagePreview(
        images: [],
        style: .frame
    )
}
