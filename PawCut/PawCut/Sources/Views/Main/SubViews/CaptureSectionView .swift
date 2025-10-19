//
//  CaptureSectionView .swift
//  PawCut
//
//  Created by Jay on 10/19/25.
//

import SwiftUI

struct CaptureSectionView: View {
    let viewModel: MainViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            MainTitleView(viewModel: viewModel)
            
            Spacer()

            PawPrimaryButton("촬영하기") {
                viewModel.tapCaptureButton()
            }
            .overlay(
                ImageComponent(
                    imageName: "main_photo",
                    size: CGSize(width: 350, height: 320)
                )
                .offset(CGSize(width: 0, height: -160))
            )
        }
        .background(
            Color("PointPurple02")
                    .clipShape(BottomRoundedShape(radius: 18))
                .ignoresSafeArea()
        )
    }
}
