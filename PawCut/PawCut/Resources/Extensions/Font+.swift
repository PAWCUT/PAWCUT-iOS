import SwiftUI

extension Font {
    static func pretendard(size: CGFloat, weight: Font.Weight) -> Font { return Font.custom("Pretendard-\(weight.fontWeightName)", size: size)
    }
}

extension Font.Weight {
    var fontWeightName: String {
        switch self {
        case .bold: return "Bold"
        case .semibold: return "SemiBold"
        case .medium: return "Medium"
        case .light: return "Light"
        case .regular: return "Regular"
        default: return "Regular"
        }
    }
}
