//
//  MainView.swift
//  PawCut
//
//  Created by donghee on 8/16/25.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        VStack {
            HStack {
                ImageComponent(
                    imageName: "logo_black",
                    size: CGSize(width: 83, height: 33)
                )
                Spacer()
                
                IconButton(imageName: "archivebox") {
                    viewModel.tapAchiveButton()
                }
                .padding(.trailing, 6)
                
                IconButton(imageName: "gearshape") {
                    viewModel.tapSettingButton()
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 43)
            
            HStack {
                PawTitleLabel.bold24( viewModel.getPetName().withComleteWordByJongsung+" 함께 행복한\n추억을 남겨 보세요!",
                                      alignment: .leading,
                                      lineLimit: 2
                )
                Spacer()
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            ImageComponent(
                imageName: "main_photo",
                size: CGSize(width: 308, height: 369)
            )
            
            Spacer()
            
            PawPrimaryButton("촬영하기") {
                viewModel.tapCaptureButton()
            }
        }
        .navigationTitle("")
    }
}

#Preview {
    MainView()
}
