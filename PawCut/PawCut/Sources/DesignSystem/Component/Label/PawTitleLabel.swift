//
//  PawLabel.swift
//  PawCut
//
//  Created by Luminouxx on 7/15/25.
//

import SwiftUI

struct PawTitleLabel: PawLabelProtocol {
    let text: String
    let style: PawTitleStyle
    let color: Color?
    let alignment: TextAlignment
    let lineLimit: Int?
    
    init(
        _ text: String,
        style: PawTitleStyle = .bold20,
        color: Color? = nil,
        alignment: TextAlignment = .leading,
        lineLimit: Int? = nil
    ) {
        self.text = text
        self.style = style
        self.color = color
        self.alignment = alignment
        self.lineLimit = lineLimit
    }
}

extension PawTitleLabel {
    static func bold24(_ text: String, color: Color? = nil, alignment: TextAlignment = .leading, lineLimit: Int? = nil) -> PawTitleLabel {
        PawTitleLabel(text, style: .bold24, color: color, alignment: alignment, lineLimit: lineLimit)
    }
    
    static func bold20(_ text: String, color: Color? = nil, alignment: TextAlignment = .leading, lineLimit: Int? = nil) -> PawTitleLabel {
        PawTitleLabel(text, style: .bold20, color: color, alignment: alignment, lineLimit: lineLimit)
    }
    
    static func semi17(_ text: String, color: Color? = nil, alignment: TextAlignment = .leading, lineLimit: Int? = nil) -> PawTitleLabel {
        PawTitleLabel(text, style: .semi17, color: color, alignment: alignment, lineLimit: lineLimit)
    }
    
    static func semi16(_ text: String, color: Color? = nil, alignment: TextAlignment = .leading, lineLimit: Int? = nil) -> PawTitleLabel {
        PawTitleLabel(text, style: .semi16, color: color, alignment: alignment, lineLimit: lineLimit)
    }
    
    static func semi14(_ text: String, color: Color? = nil, alignment: TextAlignment = .leading, lineLimit: Int? = nil) -> PawTitleLabel {
        PawTitleLabel(text, style: .semi14, color: color, alignment: alignment, lineLimit: lineLimit)
    }
}

#Preview {
    PawTitleLabel.bold24("bold24")
    PawTitleLabel.bold20("bold20")
    PawTitleLabel.semi17("semi17")
    PawTitleLabel.semi16("semi16")
    PawTitleLabel.semi14("semi14")
}
