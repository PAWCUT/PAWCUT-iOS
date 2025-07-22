//
//  FontSet.swift
//  PawCut
//
//  Created by Luminouxx on 7/14/25.
//

import SwiftUI

enum FontSet {
    enum Name: String, CaseIterable {
        case system
        case pretendard = "Pretendard"
        
        var displayName: String {
            switch self {
            case .system: return "System"
            case .pretendard: return "Pretendard"
            }
        }
    }
    
    enum Size: CGFloat, CaseIterable {
        case _12 = 12
        case _14 = 14
        case _16 = 16
        case _17 = 17
        case _20 = 20
        case _24 = 24
    }
    
    enum Weight: String, CaseIterable {
        case medium = "Medium"
        case semibold = "SemiBold"
        case bold = "Bold"
        
        var fontWeight: Font.Weight {
            switch self {
            case .medium: return .medium
            case .semibold: return .semibold
            case .bold: return .bold
            }
        }
    }
}

extension FontSet {
    static func font(name: Name, size: Size, weight: Weight) -> Font {
        switch name {
        case .system:
            return .system(size: size.rawValue, weight: weight.fontWeight)
        case .pretendard:
            return .custom("\(name.rawValue)-\(weight.rawValue)", size: size.rawValue)
        }
    }
    
    static func pretendard(size: Size, weight: Weight = .medium) -> Font {
        return font(name: .pretendard, size: size, weight: weight)
    }
    
    static func system(size: Size, weight: Weight = .medium) -> Font {
        return font(name: .system, size: size, weight: weight)
    }
}

extension FontSet {
    private struct CustomFont {
        let name: Name
        let weight: Weight
        
        var fileName: String {
            "\(name.rawValue)-\(weight.rawValue)"
        }
        
        var fileExtension: String {
            "otf"
        }
    }
    
    private static var customFonts: [CustomFont] {
        Weight.allCases.compactMap { weight in
            CustomFont(name: .pretendard, weight: weight)
        }
    }
    
    static func registerFonts() {
        customFonts.forEach { font in
            registerFont(font)
        }
    }
    
    private static func registerFont(_ customFont: CustomFont) {
        guard let fontURL = Bundle.main.url(
            forResource: customFont.fileName,
            withExtension: customFont.fileExtension
        ) else {
            debugPrint("Font file not found: \(customFont.fileName).\(customFont.fileExtension)")
            return
        }
        
        guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
              let _ = CGFont(fontDataProvider) else {
            debugPrint("Failed to create font from: \(customFont.fileName)")
            return
        }
    }
}
