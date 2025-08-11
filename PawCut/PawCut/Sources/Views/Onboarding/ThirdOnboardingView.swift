//
//  OnboardingView1.swift
//  PawCut
//
//  Created by Ethan on 7/25/25.
//

import SwiftUI

struct ThirdOnboardingView: View {
    
    @StateObject private var viewModel = ThirdOnboardingViewModel()
    
    var body: some View {
        VStack{
            Text("사진은 언제나\n다시 꺼내볼 수 있어요")
                .font(.pretendard(size: ._24 ,weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundColor(.grayScale01)
                .padding(12)
            
            Text("언제든 꺼내볼 수 있는\n따뜻한 기록이 되어줄 거예요")
                .font(.pretendard(size: ._16,weight: .medium))
                .multilineTextAlignment(.center)
                .foregroundColor(.grayScale03)
                .padding(.bottom,91)
            
            ImageComponent(
                imageName: "onboarding_3",
                size: CGSize(width: 200, height: 265)
            )
            .padding(.bottom,93)
            
            PageControl(numberOfPages: 3, currentPage: viewModel.currentPage)
            
            PawPrimaryButton("다음"){
                viewModel.tapNextButton()
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    ThirdOnboardingView()
}
