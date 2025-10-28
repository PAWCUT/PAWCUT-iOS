//
//  PawcutCamera.swift
//  PawCut
//
//  Created by 광로 on 8/12/25.
//

import AVFoundation
import SwiftUI

struct PawcutCameraView: View {
    @StateObject private var viewModel = PawcutCameraViewModel()
    
    var body: some View {
        ZStack {
            Color.grayScale01.ignoresSafeArea()
            
            (viewModel.rawImage.map { image in
                AnyView(Image(uiImage: image)
                    .resizable()
                    .scaledToFill())
            } ?? AnyView(Rectangle().fill(Color.grayScale03.opacity(0.3))))
            .frame(
                width: UIScreen.main.bounds.width,
                height: UIScreen.main.bounds.width * 4 / 3
            )
            .clipped()
            .offset(y: -40)
            
            if viewModel.showShutter {
                Color.grayScale01.opacity(1)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .animation(
                        .easeOut(duration: 0.05),
                        value: viewModel.showShutter
                    )
            }
            
            PawBodyLabel.semi16("\(viewModel.currentShotIndex) / 8", color: .grayScale06)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.grayScale06.opacity(0.2))
                .clipShape(Capsule())
                .offset(y: -270)
            
            Text("\(viewModel.countdownNumber ?? 0)")
                .font(.system(size: 100, weight: .bold))
                .foregroundColor(.white)
                .shadow(radius: 5)
                .transition(.opacity)
                .padding(.bottom, 60)
            
            PawcutCameraBottomSubView(
                zoomOptions: viewModel.zoomOptions,
                selectedZoomId: viewModel.selectedZoomId,
                cameraPosition: viewModel.cameraPosition,
                isZoomedIn: viewModel.isZoomedIn,
                onZoomChange: { zoomId in viewModel.setZoom(zoomId) },
                onToggleFrontZoom: { viewModel.toggleFrontZoom() },
                onExtendCountdown: { viewModel.extendCountdown() },
                onPerformCapture: {
                    viewModel.cancelCountdown()
                    viewModel.performCapture()
                },
                onToggleCamera: { viewModel.toggleCamera() }
            )
            if viewModel.showSoundTooltip {
                VStack {
                    HStack {
                        Spacer()
                        PawToolTip(
                            message: "소리를 설정에서 변경할 수 있어요!"
                        )
                        .padding(.top, 48)
                        .padding(.trailing, -126)
                        Spacer()
                    }
                    Spacer()
                }
                .transition(.opacity.combined(with: .scale))
                .onTapGesture {
                    viewModel.hideSoundTooltip()
                }
            }
            
        }
        .pawNavigationBar()
        .pawNavigationStyle(.camera)
        .pawNavigationBackAction {
            viewModel.tapBackButton()
        }
        .enableNativeSwipeBack(false)
        .pawNavigationTrailingItems(
            SoundIconItem(
                imageName: "pawcut_sound",
                action: viewModel.playSound
            ),
            
            FlashIconItem(
                enabledImageName: "flash_light",
                disabledImageName: "flash_dark",
                isEnabled: viewModel.isFlashEnabled,
                action: viewModel.toggleFlash
            )
        )
        .toolbar(.hidden, for: .navigationBar)
        .onChange(of: viewModel.session.isRunning) { _, isRunning in
            if isRunning {
                viewModel.startLoopedCountdown()
            }
        }
        .onDisappear {
            viewModel.cancelCountdown()
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: UIApplication.willResignActiveNotification
            )
        ) { _ in
            viewModel.pauseCountdown()
        }
    }
}

#Preview {
    PawcutCameraView()
}
