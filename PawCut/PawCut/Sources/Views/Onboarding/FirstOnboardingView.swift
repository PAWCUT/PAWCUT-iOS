//
//  OnboardingView1.swift
//  PawCut
//
//  Created by Ethan on 7/25/25.
//

import SwiftUI

// TODO: 온보딩 뷰 하나로 융합
struct FirstOnboardingView: View {
    
    @StateObject private var viewModel = FirstOnboardingViewModel()

    var body: some View {
        VStack{
            Spacer()
            
            PawTitleLabel
                .bold24(
                    "귀가 쫑긋! \n그 찰나를 담아보세요",
                    alignment: .center,
                    lineLimit: 2
                )
                .padding(12)
            
            PawBodyLabel
                .med16(
                    "우리 아이가 반응하는 소리로\n자연스러운 시선을 끌어내보세요",
                    color: .grayScale03,
                    alignment: .center,
                    lineLimit: 2
                )
            
            Spacer()
            
            ImageComponent(
                imageName: "onboarding_1",
                size: CGSize(width: 220, height: 251)
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
    FirstOnboardingView()
}
