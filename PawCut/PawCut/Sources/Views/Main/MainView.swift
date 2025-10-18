//
//  MainView.swift
//  PawCut
//
//  Created by donghee on 8/16/25.
//

import PhotosUI
import SwiftUI

struct MainHeaderView: View {
    let viewModel: MainViewModel

    var body: some View {
        HStack {
            ImageComponent(
                imageName: "logo_black",
                size: CGSize(width: 83, height: 33)
            )
            Spacer()

            IconButton(imageName: "archivebox") {
                viewModel.tapAchiveButton()
            }
            .padding(.trailing, -4)

            IconButton(imageName: "gearshape") {
                viewModel.tapSettingButton()
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 43)
    }
}

struct MainTitleView: View {
    let viewModel: MainViewModel

    var body: some View {
        HStack {
            PawTitleLabel.bold24(
                viewModel.getPetName().withComleteWordByJongsung
                    + " 함께 행복한\n추억을 남겨 보세요!",
                alignment: .leading,
                lineLimit: 2
            )
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

struct MainView: View {

    @StateObject var viewModel = MainViewModel()

    var body: some View {
        VStack {
            MainHeaderView(viewModel: viewModel)

            MainTitleView(viewModel: viewModel)

            Spacer()

            ImageComponent(
                imageName: "main_photo",
                size: CGSize(width: 308, height: 369)
            )

            Spacer()

            PawPrimaryButton("촬영하기") {
                viewModel.tapCaptureButton()
            }

            PhotosPicker(
                selection: $viewModel.importImages,
                maxSelectionCount: 8,
                matching: .images
            ) {
                Text("앱에서 불러오기")
            }.onChange(of: viewModel.importImages) {
                viewModel.tapPawcutSelectionButton()
            }
        }
        .navigationTitle("")
        .onAppear {
            viewModel.updatePetInfo()
        }
    }
}

#Preview {
    MainView()
}
