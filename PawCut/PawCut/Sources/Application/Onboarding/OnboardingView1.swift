//
//  OnboardingView1.swift
//  PawCut
//
//  Created by Ethan on 7/25/25.
//

import SwiftUI

struct OnboardingView1: View {
    @State private var currentPage: Int = 0
    var body: some View {
        Spacer()
        VStack{
            Text("귀가 쫑긋! \n그 찰나를 담아보세요")
                .font(.pretendard(size: ._24 ,weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundColor(.grayScale01)
                .padding(12)
            
            Text("우리 아이가 반응하는 소리로\n자연스러운 시선을 끌어내보세요")
                .font(.pretendard(size: ._16,weight: .medium))
                .multilineTextAlignment(.center)
                .foregroundColor(.grayScale03)
                .padding(.bottom,102)
            
            ImageComponent(
                imageName: "onboarding_1",
                size: CGSize(width: 220, height: 251)
            )
            .padding(.bottom,96)
            PageControl(numberOfPages: 3, currentPage:currentPage)
            
            PawPrimaryButton("다음"){
                print("다음")
            }
            
            
        }
    }
}

#Preview {
    OnboardingView1()
}
