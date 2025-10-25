//
//  MainView.swift
//  PawCut
//
//  Created by donghee on 8/16/25.
//

import PhotosUI
import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewModel()

    var body: some View {
        VStack(spacing: 0) {
            MainHeaderView(
                tapAchiveButton: {
                    viewModel.tapAchiveButton()
                },
                tapSettingButton: {
                    viewModel.tapSettingButton()
                }
            )

            CaptureSectionView(
                tapCaptureButton: {
                    viewModel.tapCaptureButton()
                },
                getPetName: {
                    viewModel.getPetName()
                }
            )

            PhotoImportPickerView(
                importImages: $viewModel.importImages,
                tapPawcutSelectionButton: {
                    viewModel.tapPawcutSelectionButton()
                }
            )
        }
    }
}

#Preview {
    MainView()
}
