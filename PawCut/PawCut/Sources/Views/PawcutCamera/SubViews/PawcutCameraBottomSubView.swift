//
//  PawcutCameraBottomSubView.swift
//  PawCut
//
//  Created by 광로 on 9/24/25.
//

import SwiftUI

struct PawcutCameraBottomSubView: View {
    @ObservedObject var viewModel: PawcutCameraViewModel
    
    var body: some View {
        VStack {
            Spacer()
            if viewModel.cameraPosition == .back {
                HStack(spacing: 20) {
                    ForEach(viewModel.zoomOptions, id: \.id) { option in
                        let isSelected = option.id == viewModel.selectedZoomId
                        Button(action: {
                            viewModel.setZoom(option.id)
                        }) {
                            PawBodyLabel.semi16(option.title, color: .grayScale06)
                                .frame(
                                    width: isSelected ? 36 : 24,
                                    height: isSelected ? 36 : 24
                                )
                                .background(Color.grayScale06.opacity(0.3))
                                .clipShape(Circle())
                                .shadow(radius: 2)
                        }
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.grayScale06.opacity(0.1))
                .cornerRadius(105)
                .padding(.bottom, 76)
            } else {
                Button(action: {
                    viewModel.toggleFrontZoom()
                }) {
                    ImageComponent(
                        imageName: viewModel.isZoomedIn ? "zoom_out" : "zoom_in",
                        size: CGSize(width: 35, height: 35)
                    )
                    .frame(width: 35, height: 35)
                    .background(Color.grayScale06.opacity(0.35))
                    .clipShape(Circle())
                }
                .scaleEffect(viewModel.isZoomedIn ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: viewModel.isZoomedIn)
                .padding(.bottom, 76)
            }
            HStack(spacing: 77) {
                Button(action: {
                    viewModel.extendCountdown()
                }) {
                    ImageComponent(
                        imageName: "timer_icon",
                        size: CGSize(width: 48, height: 48)
                    )
                }
                
                Button(action: {
                    viewModel.cancelCountdown()
                    viewModel.performCapture()
                }) {
                    ImageComponent(
                        imageName: "camera_icon",
                        size: CGSize(width: 68, height: 82)
                    )
                }
                
                Button(action: {
                    viewModel.toggleCamera()
                }) {
                    ImageComponent(
                        imageName: "stitch_icon",
                        size: CGSize(width: 48, height: 48)
                    )
                }
            }
        }
        .padding(.bottom, 20)
    }
}

#Preview {
    PawcutCameraBottomSubView(viewModel: PawcutCameraViewModel())
}