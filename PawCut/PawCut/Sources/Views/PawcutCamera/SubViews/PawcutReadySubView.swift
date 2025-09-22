//
//  PawcutReadySubView.swift
//  PawCut
//
//  Created by 광로 on 9/21/25.
//

import SwiftUI

struct PawcutReadySubView: View {
    var body: some View {
        VStack(spacing: 28) {
            ImageComponent(
                imageName: "onboarding_1",
                size: CGSize(width: 190, height: 217)
            )
            PawBodyLabel.semi20(
                "촬영이 바로 시작됩니다\n준비해 주세요!",
                color: .grayScale01,
                alignment: .center
            )
        }
    }
}

#Preview {
    ZStack {
        Color.grayScale06
            .ignoresSafeArea()
        PawcutReadySubView()
    }
}
