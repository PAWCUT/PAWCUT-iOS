//
//  OnboardingView1.swift
//  PawCut
//
//  Created by Ethan on 7/25/25.
//

import SwiftUI

// TODO: 삭제 예정
struct ThirdOnboardingView: View {
    
    @StateObject private var viewModel = ThirdOnboardingViewModel()
    
    var body: some View {
        VStack{
            Spacer()
            
            PawTitleLabel
                .bold24(
                    "사진은 언제나\n다시 꺼내볼 수 있어요",
                    alignment: .center,
                    lineLimit: 2
                )
                .padding(12)
            
            PawBodyLabel
                .med16(
                    "언제든 꺼내볼 수 있는\n따뜻한 기록이 되어줄 거예요",
                    color: .grayScale03,
                    alignment: .center,
                    lineLimit: 2
                )
            
            Spacer()
            
            ImageComponent(
                imageName: "onboarding_3",
                size: CGSize(width: 200, height: 265)
            )
            
            Spacer()
            
            PageControl(numberOfPages: 3, currentPage: viewModel.currentPage)
            
            PawPrimaryButton("다음"){
                viewModel.tapNextButton()
            }
        }
    }
}

#Preview {
    ThirdOnboardingView()
}
