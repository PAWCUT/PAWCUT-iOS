//
//  PawcutCameraBottomSubView.swift
//  PawCut
//
//  Created by 광로 on 9/24/25.
//

import SwiftUI

struct PawcutCameraBottomSubView: View {

    let zoomOptions: [PawcutCameraViewModel.ZoomOption]
    let selectedZoomId: String
    let cameraPosition: PawcutCameraViewModel.CameraPosition
    let isZoomedIn: Bool

    let onZoomChange: (String) -> Void
    let onToggleFrontZoom: () -> Void
    let onExtendCountdown: () -> Void
    let onPerformCapture: () -> Void
    let onToggleCamera: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            if cameraPosition == .back {
                HStack(spacing: 20) {
                    ForEach(zoomOptions, id: \.id) { option in
                        let isSelected = option.id == selectedZoomId
                        Button(action: {
                            onZoomChange(option.id)
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
                    onToggleFrontZoom()
                }) {
                    ImageComponent(
                        imageName: isZoomedIn ? "zoom_out" : "zoom_in",
                        size: CGSize(width: 35, height: 35)
                    )
                    .frame(width: 35, height: 35)
                    .background(Color.grayScale06.opacity(0.35))
                    .clipShape(Circle())
                }
                .scaleEffect(isZoomedIn ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isZoomedIn)
                .padding(.bottom, 76)
            }
            HStack(spacing: 77) {
                Button(action: {
                    onExtendCountdown()
                }) {
                    ImageComponent(
                        imageName: "timer_icon",
                        size: CGSize(width: 48, height: 48)
                    )
                }
                
                Button(action: {
                    onPerformCapture()
                }) {
                    ImageComponent(
                        imageName: "camera_icon",
                        size: CGSize(width: 68, height: 82)
                    )
                }
                
                Button(action: {
                    onToggleCamera()
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
    PawcutCameraBottomSubView(
        zoomOptions: [
            PawcutCameraViewModel.ZoomOption(id: "0.5", title: ".5"),
            PawcutCameraViewModel.ZoomOption(id: "1.0", title: "1x"),
            PawcutCameraViewModel.ZoomOption(id: "2.0", title: "2")
        ],
        selectedZoomId: "1.0",
        cameraPosition: .back,
        isZoomedIn: false,
        onZoomChange: { _ in },
        onToggleFrontZoom: { },
        onExtendCountdown: { },
        onPerformCapture: { },
        onToggleCamera: { }
    )
}
