//
//  PawcutTip.swift
//  PawCut
//
//  Created by 광로 on 7/17/25.
//

import SwiftUI

struct PawcutTipView: View {
    @StateObject private var viewModel = PawcutTipViewModel()
    
    var body: some View {
        ZStack {
            Color.grayScale06
                .ignoresSafeArea()
            VStack(spacing: 0) {
                PawcutTipSubView(tips: viewModel.tips)
                Spacer()
                PawPrimaryButton("촬영하기") {
                    viewModel.tapNextButton()
                }
            }
        }
    }
}

#Preview {
    PawcutTipView()
}
