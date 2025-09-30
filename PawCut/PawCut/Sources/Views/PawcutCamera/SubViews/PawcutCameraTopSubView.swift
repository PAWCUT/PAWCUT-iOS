//
//  PawcutCameraTopSubView.swift
//  PawCut
//
//  Created by 광로 on 9/24/25.
//

import SwiftUI

struct PawcutCameraTopSubView: View {
    @ObservedObject var viewModel: PawcutCameraViewModel
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    viewModel.tapBackButton()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.grayScale06)
                }
                .frame(height: 44)
                .contentShape(Rectangle())
                
                Spacer()
                
                Button(action: {
                    viewModel.playSound()
                }) {
                    ImageComponent(
                        imageName: "pawcut_sound",
                        size: CGSize(width: 22, height: 22)
                    )
                    .scaleEffect(viewModel.soundButtonScale)
                    .animation(
                        .easeInOut(duration: 1.5).repeatForever(
                            autoreverses: true
                        ),
                        value: viewModel.soundButtonScale
                    )
                }
                
                Button(action: {
                    viewModel.toggleFlash()
                }) {
                    ImageComponent(
                        imageName: viewModel.isFlashEnabled
                        ? "flash_light" : "flash_dark",
                        size: CGSize(width: 22, height: 22)
                    )
                    .opacity(viewModel.isFlashEnabled ? 1.0 : 1.0)
                    .scaleEffect(viewModel.isFlashEnabled ? 1.1 : 1.0)
                    .animation(
                        .easeInOut(duration: 0.2),
                        value: viewModel.isFlashEnabled
                    )
                }
                .frame(width: 36, height: 42)
            }
            .padding(.horizontal, 16)
            .padding(.top, 0)
            Spacer()
        }
    }
}

#Preview {
    PawcutCameraTopSubView(viewModel: PawcutCameraViewModel())
}
