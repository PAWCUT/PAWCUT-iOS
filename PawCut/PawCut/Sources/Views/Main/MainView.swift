//
//  MainView.swift
//  PawCut
//
//  Created by donghee on 8/16/25.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        HStack {
            ImageComponent(
                imageName: "logo_black",
                size: CGSize(width: 83, height: 33)
            )
            Spacer()
            ImageComponent(
                imageName: "archivebox" ,
                size: CGSize(width: 20, height: 18)
            )
            .padding(16)
            ImageComponent(
                imageName: "gearshape",
                size: CGSize(width: 19, height: 19)
            )
        }
        .padding(.horizontal, 20)
        .padding(.vertical,43)
        HStack{
            PawTitleLabel
                .bold24(
                    "해피와 함께 행복한\n추억을 남겨 보세요!",
                    alignment: .center,
                    lineLimit: 2
                )
            Spacer()
        }
        .padding(.horizontal,20)
        Spacer()
        VStack{
            Spacer()
            ImageComponent(
                imageName: "main_photo",
                size: CGSize(width: 308, height: 369)
            )
            Spacer()
            PawPrimaryButton("촬영하기") {
                
            }
        }
    }
}

#Preview {
    MainView()
}
