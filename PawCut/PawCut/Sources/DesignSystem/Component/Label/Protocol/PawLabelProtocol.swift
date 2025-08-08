//
//  PawLabelProtocol.swift
//  PawCut
//
//  Created by Luminouxx on 8/9/25.
//

import SwiftUI

protocol PawLabelProtocol: View {
    associatedtype StyleType: PawTypographyStyle
    
    var text: String { get }
    var style: StyleType { get }
    var color: Color? { get }
    var alignment: TextAlignment { get }
    var lineLimit: Int? { get }
    
    init(_ text: String, style: StyleType, color: Color?, alignment: TextAlignment, lineLimit: Int?)
}

extension PawLabelProtocol {
    var body: some View {
        Text(text)
            .font(style.font)
            .foregroundColor(color ?? style.defaultColor)
            .multilineTextAlignment(alignment)
            .lineLimit(lineLimit)
    }
}
