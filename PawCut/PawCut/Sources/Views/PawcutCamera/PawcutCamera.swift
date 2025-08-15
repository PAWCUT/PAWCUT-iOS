//
//  PawcutCamera.swift
//  PawCut
//
//  Created by 광로 on 8/12/25.
//

import AVFoundation
import SwiftUI

struct PawcutCamera: View {
    @StateObject private var viewModel = PawcutCameraViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            backgroundLayer
            cameraPreviewLayer
            shutterAnimationLayer
            uiOverlayLayer
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            viewModel.startLoopedCountdown()
        }
        .onDisappear {
            viewModel.cancelCountdown()
        }
    }

    // MARK: - View Components
    private var backgroundLayer: some View {
        Color.black.ignoresSafeArea()
    }

    private var cameraPreviewLayer: some View {
        Group {
            if let image = viewModel.rawImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: UIScreen.main.bounds.width,
                        height: UIScreen.main.bounds.width * 4 / 3
                    )
                    .clipped()
                    .offset(y: -40)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(
                        width: UIScreen.main.bounds.width,
                        height: UIScreen.main.bounds.width * 4 / 3
                    )
                    .offset(y: -40)
            }
        }
    }

    private var shutterAnimationLayer: some View {
        Group {
            if viewModel.showShutter {
                Color.black.opacity(1)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .animation(
                        .easeOut(duration: 0.05),
                        value: viewModel.showShutter
                    )
            }
        }
    }

    private var uiOverlayLayer: some View {
        ZStack {
            topNavigationView
            shotProgressView
            countdownView
            bottomControlsView
            tooltipView
        }
    }

    private var topNavigationView: some View {
        VStack {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.white)
                }
                .frame(width: 33, height: 44)

                Spacer()

                Button(action: {
                }) {
                    ImageComponent(
                        imageName: "pawcut_sound",
                        size: CGSize(width: 22, height: 22)
                    )
                }

                Button(action: {
                    viewModel.toggleFlash()
                }) {
                    ImageComponent(
                        imageName: "flash_light",
                        size: CGSize(width: 22, height: 22)
                    )
                }
                .frame(width: 36, height: 42)
            }
            .padding(.horizontal, 20)
            .padding(.top, 0)

            Spacer()
        }
    }

    private var shotProgressView: some View {
        Text("\(viewModel.currentShotIndex) / 8")
            .pretendardFont(size: ._16, weight: .semibold)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.white.opacity(0.2))
            .foregroundColor(.white)
            .clipShape(Capsule())
            .offset(y: -270)
    }

    private var countdownView: some View {
        Group {
            if let timeLeft = viewModel.countdownNumber {
                Text("\(timeLeft)")
                    .font(.system(size: 100, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
    }

    private var bottomControlsView: some View {
        VStack {
            Spacer()
            if viewModel.cameraPosition == .back {
                zoomControlView
                    .padding(.bottom, 76)
            }
            bottomButtonsView
        }
        .padding(.bottom, 20)
    }

    private var zoomControlView: some View {
        HStack(spacing: 20) {
            ForEach(viewModel.zoomOptions, id: \.id) { option in
                let isSelected = option.id == viewModel.selectedZoomId
                Button(action: {
                    viewModel.setZoom(option.id)
                }) {
                    Text(option.title)
                        .pretendardFont(size: ._14, weight: .semibold)
                        .foregroundColor(Color.white)
                        .frame(
                            width: isSelected ? 36 : 24,
                            height: isSelected ? 36 : 24
                        )
                        .background(Color.white.opacity(0.3))
                        .clipShape(Circle())
                        .shadow(radius: 2)
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.white.opacity(0.1))
        .cornerRadius(105)
    }

    private var bottomButtonsView: some View {
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

    private var tooltipView: some View {
        Group {
            if viewModel.showSoundTooltip {
                VStack {
                    HStack {
                        Spacer()

                        VStack(spacing: 0) {
                            PawToolTip(
                                message: "소리를 설정에서 변경할 수 있어요!"
                            )
                        }
                        .padding(.top, 50)
                        .padding(.trailing, -120)

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
    }
}

#Preview {
    PawcutCamera()
}
