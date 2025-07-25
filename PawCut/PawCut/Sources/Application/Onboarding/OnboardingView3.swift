//
//  OnboardingView1.swift
//  PawCut
//
//  Created by Ethan on 7/25/25.
//

import SwiftUI

struct OnboardingView3: View {
    @State private var currentPage: Int = 2
    var body: some View {
        Spacer()
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
            PageControl(numberOfPages: 3, currentPage:currentPage)
            
            PawPrimaryButton("다음"){
                print("다음")
            }
            
            
        }
    }
}

#Preview {
    OnboardingView3()
}
