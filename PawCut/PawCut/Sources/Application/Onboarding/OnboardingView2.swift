//
//  OnboardingView1.swift
//  PawCut
//
//  Created by Ethan on 7/25/25.
//

import SwiftUI

struct OnboardingView2: View {
    @State private var currentPage: Int = 1
    var body: some View {
        Spacer()
        VStack{
            Text("특별한 날에는,\n포우-컷으로 남겨보세요")
                .font(.pretendard(size: ._24 ,weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundColor(.grayScale01)
                .padding(12)
            
            Text("함께하는 소중한 하루를\n오래도록 간직할 수 있어요")
                .font(.pretendard(size: ._16,weight: .medium))
                .multilineTextAlignment(.center)
                .foregroundColor(.grayScale03)
                .padding(.bottom,97)
            
            ImageComponent(
                imageName: "onboarding_2",
                size: CGSize(width: 180, height: 258)
            )
            .padding(.bottom,94)
            PageControl(numberOfPages: 3, currentPage:currentPage)
            
            PawPrimaryButton("다음"){
                print("다음")
            }
            
            
        }
    }
}

#Preview {
    OnboardingView2()
}
