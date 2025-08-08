//
//  PawButtonLabel.swift
//  PawCut
//
//  Created by Luminouxx on 8/9/25.
//

import SwiftUI

struct PawButtonLabel: PawLabelProtocol {
    let text: String
    let style: PawButtonStyle
    let color: Color?
    let alignment: TextAlignment
    let lineLimit: Int?
    
    init(
        _ text: String,
        style: PawButtonStyle = .semi16,
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

extension PawButtonLabel {
    static func semi14(_ text: String, color: Color? = nil, alignment: TextAlignment = .leading, lineLimit: Int? = nil) -> PawButtonLabel {
        PawButtonLabel(text, style: .semi14, color: color, alignment: alignment, lineLimit: lineLimit)
    }
    
    static func semi16(_ text: String, color: Color? = nil, alignment: TextAlignment = .leading, lineLimit: Int? = nil) -> PawButtonLabel {
        PawButtonLabel(text, style: .semi16, color: color, alignment: alignment, lineLimit: lineLimit)
    }
    
    static func med12(_ text: String, color: Color? = nil, alignment: TextAlignment = .leading, lineLimit: Int? = nil) -> PawButtonLabel {
        PawButtonLabel(text, style: .med12, color: color, alignment: alignment, lineLimit: lineLimit)
    }
}

#Preview {
    PawButtonLabel.semi14("semi14")
    PawButtonLabel.semi16("semi16")
    PawButtonLabel.med12("med12")
}
