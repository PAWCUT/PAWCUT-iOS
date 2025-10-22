//
//  CaptureSectionView .swift
//  PawCut
//
//  Created by Jay on 10/19/25.
//

import SwiftUI

struct CaptureSectionView: View {
    var tapCaptureButton: () -> Void
    var getPetName: () -> String

    var body: some View {
        VStack(spacing: 0) {
            PawTitleLabel.bold24(
                getPetName().withComleteWordByJongsung
                    + " 함께 행복한\n추억을 남겨 보세요!",
                alignment: .center,
                lineLimit: 2
            )
            .padding(.top, 20)
            .padding(.bottom, 3)

            Spacer()

            PawPrimaryButton("촬영하기") {
                tapCaptureButton()
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
