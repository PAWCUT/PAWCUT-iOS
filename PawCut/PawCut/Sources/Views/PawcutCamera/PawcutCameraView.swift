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
                    .fill(Color.grayScale03.opacity(0.3))
                    .frame(
                        width: UIScreen.main.bounds.width,
                        height: UIScreen.main.bounds.width * 4 / 3
                    )
                    .offset(y: -40)
            }
            
            if viewModel.showShutter {
                Color.grayScale01.opacity(1)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .animation(
                        .easeOut(duration: 0.05),
                        value: viewModel.showShutter
                    )
            }
            
            PawcutCameraTopSubView(viewModel: viewModel)
            
            PawBodyLabel.semi16("\(viewModel.currentShotIndex) / 8", color: .grayScale06)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.grayScale06.opacity(0.2))
                .clipShape(Capsule())
                .offset(y: -270)
            
            if let timeLeft = viewModel.countdownNumber {
                    Text("\(timeLeft)")
                    .font(.system(size: 100, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                    .transition(.opacity)
                    .padding(.bottom, 60)

            }
            
            PawcutCameraBottomSubView(viewModel: viewModel)
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
