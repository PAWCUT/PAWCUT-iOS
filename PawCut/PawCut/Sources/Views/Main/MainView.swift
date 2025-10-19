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
            MainHeaderView(viewModel: viewModel)
            
            CaptureSectionView(viewModel: viewModel)

            PhotoImportPickerView(
                importImages: $viewModel.importImages,
                onImport: {
                    viewModel.tapPawcutSelectionButton()
                }
            )
        }
    }
}

#Preview {
    MainView()
}
