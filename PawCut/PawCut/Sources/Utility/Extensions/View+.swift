//
//  View+.swift
//  PawCut
//
//  Created by Luminouxx on 7/14/25.
//

import SwiftUI

extension View {
    func pretendardFont(size: FontSet.Size, weight: FontSet.Weight = .bold) -> some View {
        self.font(.pretendard(size: size, weight: weight))
    }
}
