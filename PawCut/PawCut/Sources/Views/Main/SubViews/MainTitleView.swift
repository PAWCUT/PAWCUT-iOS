//
//  MainTitleView.swift
//  PawCut
//
//  Created by Jay on 10/19/25.
//

import SwiftUI

struct MainTitleView: View {
    let viewModel: MainViewModel

    var body: some View {
        HStack {
            PawTitleLabel.bold24(
                viewModel.getPetName().withComleteWordByJongsung
                    + " 함께 행복한\n추억을 남겨 보세요!",
                alignment: .center,
                lineLimit: 2
            )
        }
        .padding(.top, 20)
        .padding(.bottom, 3)
    }
}
