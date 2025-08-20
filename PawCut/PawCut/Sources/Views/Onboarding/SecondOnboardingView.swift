//
//  OnboardingView1.swift
//  PawCut
//
//  Created by Ethan on 7/25/25.
//

import SwiftUI

struct SecondOnboardingView: View {
    
    @StateObject private var viewModel = SecondOnboardingViewModel()
    
    var body: some View {
        VStack{
            PawTitleLabel
                .bold24(
                    "특별한 날에는,\n포우-컷으로 남겨보세요",
                    alignment: .center,
                    lineLimit: 2
                )
                .padding(12)
            
            PawBodyLabel
                .med16(
                    "함께하는 소중한 하루를\n오래도록 간직할 수 있어요",
                    color: .grayScale03,
                    alignment: .center,
                    lineLimit: 2
                )
                .padding(.bottom, 97)
            
            ImageComponent(
                imageName: "onboarding_2",
                size: CGSize(width: 180, height: 258)
            )
            .padding(.bottom,94)
            
            PageControl(numberOfPages: 3, currentPage: viewModel.currentPage)
            
            PawPrimaryButton("다음"){
                viewModel.tapNextButton()
            }
        }
    }
}

#Preview {
    SecondOnboardingView()
}
