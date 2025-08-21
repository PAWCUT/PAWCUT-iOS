//
//  ZoomableAsyncPhotoView.swift
//  PawCut
//
//  Created by taeni on 8/21/25.
//

import SwiftUI

struct ZoomableAsyncPhotoImageView: View {
    let fileName: String
    var onScaleChanged: (CGFloat) -> Void // 스케일 변경을 외부에 알리는 클로저
    
    @State private var image: UIImage?
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var isZoomed: Bool = false
    
    private let maxScale: CGFloat = 4.0
    
    // 애셋 이미지 로딩 초기화
    init(assetName: String, onScaleChanged: @escaping (CGFloat) -> Void) {
        self.fileName = assetName
        self.onScaleChanged = onScaleChanged
    }
    
    // 파일 이미지 로딩 초기화
    init(fileName: String, onScaleChanged: @escaping (CGFloat) -> Void) {
        self.fileName = fileName
        self.onScaleChanged = onScaleChanged
    }
    
    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(scale)
                .onTapGesture(count: 2) {
                    withAnimation(.spring()) {
                        if scale > 1.0 {
                            scale = 1.0
                        } else {
                            scale = 2.5 // 더블 탭 시 줌 인
                        }
                    }
                }
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            let delta = value / lastScale
                            lastScale = value
                            scale *= delta
                        }
                        .onEnded { _ in
                            lastScale = 1.0
                            withAnimation(.spring()) {
                                scale = max(1.0, min(scale, maxScale))
                            }
                        }
                )
                .onChange(of: scale) { _, newScale in
                    withAnimation(.spring()) {
                        isZoomed = newScale > 1.0
                        onScaleChanged(newScale)
                    }
                }
        } else {
            Image("empty_image")
                .frame(maxWidth: .infinity)
                .background(Color.grayScale06)
                .onAppear {
                    loadImage()
                }
        }
    }
    
    private func loadImage() {
        Task {
            if fileName.lowercased().hasSuffix(".jpg") || fileName.lowercased().hasSuffix(".jpeg") || fileName.lowercased().hasSuffix(".png") {
                self.image = await ImageFileManager.shared.loadImage(fileName: fileName)
            } else {
                self.image = UIImage(named: fileName)
            }
        }
    }
}

#Preview("가로 꽉 채우기 (기본)") {
    ZoomableAsyncPhotoImageView(fileName: "sample_image3", onScaleChanged: { CGFloat in
        print("yeah!")
    })
        .frame(maxWidth: .infinity)
}

#Preview("전체 이미지 맞춤") {
    ZoomableAsyncPhotoImageView(fileName: "sample_image2", onScaleChanged: { CGFloat in
        print("yeah!")
    })
        .frame(height: 300)
}
