//
//  PawcutReady.swift
//  PawCut
//
//  Created by 광로 on 7/17/25.
//

import SwiftUI

struct PawcutReady: View {
    var body: some View {
        ZStack {
            Color("GrayScale06Color")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
           
                VStack(spacing: 28) {
                  
                    Image("onboarding_first")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 190, height: 217)
                    
                  
                    Text("촬영이 바로 시작됩니다\n준비해 주세요!")
                        .pretendardFont(size: ._20, weight: .semibold)
                        .foregroundColor(Color("GrayScale01Color"))
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    PawcutReady()
}
