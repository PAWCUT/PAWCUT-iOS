//
//  PawTypographyStyle.swift
//  PawCut
//
//  Created by Luminouxx on 8/6/25.
//

import SwiftUI

protocol PawTypographyStyle {
    var font: Font { get }
    var defaultColor: Color { get }
}

enum PawTitleStyle: PawTypographyStyle {
    case bold24, bold20, semi17, semi16, semi14
    
    var font: Font {
        switch self {
        case .bold24: return FontSet.pretendard(size: ._24, weight: .bold)
        case .bold20: return FontSet.pretendard(size: ._20, weight: .bold)
        case .semi17: return FontSet.pretendard(size: ._17, weight: .semibold)
        case .semi16: return FontSet.pretendard(size: ._16, weight: .semibold)
        case .semi14: return FontSet.pretendard(size: ._14, weight: .semibold)
        }
    }
    
    var defaultColor: Color {
        return .grayScale01
    }
}

enum PawBodyStyle: PawTypographyStyle {
    case med16, med14, semi16, semi20
    
    var font: Font {
        switch self {
        case .med16: return FontSet.pretendard(size: ._16, weight: .medium)
        case .med14: return FontSet.pretendard(size: ._14, weight: .medium)
        case .semi16: return FontSet.pretendard(size: ._16, weight: .semibold)
        case .semi20: return FontSet.pretendard(size: ._20, weight: .semibold)
        }
    }
    
    var defaultColor: Color {
        return .grayScale02
    }
}

enum PawButtonStyle: PawTypographyStyle {
    case semi16, semi14, med12
    
    var font: Font {
        switch self {
        case .semi16: return FontSet.pretendard(size: ._16, weight: .semibold)
        case .semi14: return FontSet.pretendard(size: ._14, weight: .semibold)
        case .med12: return FontSet.pretendard(size: ._12, weight: .medium)
        }
    }
    
    var defaultColor: Color {
        return .grayScale01
    }
}
