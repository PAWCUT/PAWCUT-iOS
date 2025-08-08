//
//  PawBodyLabel.swift
//  PawCut
//
//  Created by Luminouxx on 8/9/25.
//

import SwiftUI

struct PawBodyLabel: PawLabelProtocol {
    let text: String
    let style: PawBodyStyle
    let color: Color?
    let alignment: TextAlignment
    let lineLimit: Int?
    
    init(
        _ text: String,
        style: PawBodyStyle = .med16,
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

extension PawBodyLabel {
    static func med14(_ text: String, color: Color? = nil, alignment: TextAlignment = .leading, lineLimit: Int? = nil) -> PawBodyLabel {
        PawBodyLabel(text, style: .med14, color: color, alignment: alignment, lineLimit: lineLimit)
    }
    
    static func med16(_ text: String, color: Color? = nil, alignment: TextAlignment = .leading, lineLimit: Int? = nil) -> PawBodyLabel {
        PawBodyLabel(text, style: .med16, color: color, alignment: alignment, lineLimit: lineLimit)
    }
    
    static func semi16(_ text: String, color: Color? = nil, alignment: TextAlignment = .leading, lineLimit: Int? = nil) -> PawBodyLabel {
        PawBodyLabel(text, style: .semi16, color: color, alignment: alignment, lineLimit: lineLimit)
    }
    
    static func semi20(_ text: String, color: Color? = nil, alignment: TextAlignment = .leading, lineLimit: Int? = nil) -> PawBodyLabel {
        PawBodyLabel(text, style: .semi20, color: color, alignment: alignment, lineLimit: lineLimit)
    }
}

#Preview {
    VStack {
        PawBodyLabel.med16("med16")
        PawBodyLabel.med14("med14")
        PawBodyLabel.semi16("semi16")
        PawBodyLabel.semi20("semi20")
    }
}
