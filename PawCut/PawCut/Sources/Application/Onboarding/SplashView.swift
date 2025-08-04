//
//  SplashView.swift
//  PawCut
//
//  Created by Ethan on 7/25/25.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack{
            Color.grayScale01
                .ignoresSafeArea()
            
            VStack(spacing: 16){
                
                Text("귀가 쫑긋, 추억이 찰칵!")
                    .foregroundColor(Color.grayScale06)
                    .font(.pretendard(size: ._16 ,weight: .semibold))
                ImageComponent(
                    imageName: "logo_white",
                    size: CGSize(width: 167, height: 66)
                )
            }
        }
    }
}

#Preview {
    SplashView()
}
