import SwiftUI

enum GridImagePreviewStyle {
    case selection
    case frame

    var metrics:
        (
            imagesWidth: CGFloat,
            imagesHeight: CGFloat,
            frameWidth: CGFloat,
            frameHeight: CGFloat,
            logoHeight: CGFloat,
            logoTopPadding: CGFloat
        )
    {
        switch self {
        case .selection:
            return (
                imagesWidth: 100,
                imagesHeight: 132,
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

struct PawcutGridImagePreview: View {
    let images: [UIImage]
    let frameOverlay: UIImage?
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
                            Spacer().frame(width: 7)
                        }

                        let index = row * 2 + col

                        if index < images.count {
                            Image(uiImage: images[index])
                                .resizable()
                                .frame(
                                    width: style.metrics.imagesWidth,
                                    height: style.metrics.imagesHeight
                                )
                                .clipped()
                                .overlay {
                                    if style == .selection {
                                        Rectangle()
                                            .strokeBorder(
                                                Color("GrayScale01"),
                                                lineWidth: 1
                                            )
                                    }
                                }
                        } else {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(
                                    width: style.metrics.imagesWidth,
                                    height: style.metrics.imagesHeight
                                )
                                .overlay {
                                    if style == .selection {
                                        Rectangle()
                                            .strokeBorder(
                                                Color("GrayScale01"),
                                                lineWidth: 1
                                            )
                                    }
                                }
                        }
                    }
                }
            }
            Spacer()
        }
        .padding(.top, 10)
        .frame(
            width: style.metrics.frameWidth,
            height: style.metrics.frameHeight
        )
        .overlay(
            Image(uiImage: frameOverlay ?? UIImage(named: "snow_frame")!)
                .resizable()
                .frame(
                    width: style.metrics.frameWidth,
                    height: style.metrics.frameHeight
                )
                .overlay(
                    Rectangle()
                        .stroke(
                            Color("GrayScale01"),
                            lineWidth: 1
                        )
                )
                .allowsHitTesting(false)
        )
    }
}

#Preview {
    PawcutGridImagePreview(
        images: {
            if let image = UIImage(named: "save_cat") {
                return [image]
            } else {
                return []
            }
        }(),
        frameOverlay: UIImage(named: "snow_frame"),
        style: .frame
    )
}
