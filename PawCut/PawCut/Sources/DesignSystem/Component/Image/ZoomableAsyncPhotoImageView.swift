//
//  ZoomableAsyncPhotoImageView.swift
//  PawCut
//
//  Created by taeni on 8/21/25.
//

import SwiftUI

struct ZoomableAsyncPhotoImageView: View {
    let fileName: String
    let onScaleChanged: (CGFloat) -> Void
    
    @State private var image: UIImage?
    @State private var currentScale: CGFloat = 1.0
    @State private var baseScale: CGFloat = 1.0
    @State private var currentOffset: CGSize = .zero
    @State private var baseOffset: CGSize = .zero
    
    private let minScale: CGFloat = 1.0
    private let maxScale: CGFloat = 4.0
    
    init(fileName: String, onScaleChanged: @escaping (CGFloat) -> Void) {
        self.fileName = fileName
        self.onScaleChanged = onScaleChanged
    }
    
    var body: some View {
        GeometryReader { geometry in
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width)
                    .scaleEffect(currentScale)
                    .offset(limitedOffset(for: geometry, image: image))
                    .gesture(makeZoomAndPanGesture(for: geometry, image: image))
                    .onTapGesture(count: 2) {
                        handleDoubleTap()
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
        .onChange(of: currentScale) { _, newScale in
            onScaleChanged(newScale)
        }
    }
    
    private func makeZoomAndPanGesture(for geometry: GeometryProxy, image: UIImage) -> some Gesture {
        SimultaneousGesture(
            magnificationGesture(),
            dragGesture(for: geometry, image: image)
        )
    }
    
    // pinch zoom
    private func magnificationGesture() -> some Gesture {
        MagnificationGesture()
            .onChanged { value in
                let newScale = baseScale * value
                currentScale = min(max(newScale, minScale), maxScale)
            }
            .onEnded { _ in
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    if currentScale < minScale {
                        currentScale = minScale
                        currentOffset = .zero
                        baseOffset = .zero
                    } else if currentScale > maxScale {
                        currentScale = maxScale
                    }
                }
                baseScale = currentScale
            }
    }
    
    // pan gesture
    private func dragGesture(for geometry: GeometryProxy, image: UIImage) -> some Gesture {
        DragGesture()
            .onChanged { value in
                guard currentScale > 1.0 else { return }
                
                let newOffset = CGSize(
                    width: baseOffset.width + value.translation.width,
                    height: baseOffset.height + value.translation.height
                )
                currentOffset = newOffset
            }
            .onEnded { _ in
                baseOffset = currentOffset
            }
    }
    
    // double tap
    private func handleDoubleTap() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            if currentScale > 1.0 {
                currentScale = 1.0
                currentOffset = .zero
                baseOffset = .zero
            } else {
                currentScale = 2.5
            }
        }
        baseScale = currentScale
    }
    
    // device limited
    private func limitedOffset(for geometry: GeometryProxy, image: UIImage) -> CGSize {
        guard currentScale > 1.0 else {
            return .zero
        }
        
        let imageSize = calculateImageSize(for: geometry, image: image)
        let scaledWidth = imageSize.width * currentScale
        let scaledHeight = imageSize.height * currentScale
        
        let maxOffsetX = max(0, (scaledWidth - geometry.size.width) / 2)
        let maxOffsetY = max(0, (scaledHeight - geometry.size.height) / 2)
        
        let limitedX = min(max(currentOffset.width, -maxOffsetX), maxOffsetX)
        let limitedY = min(max(currentOffset.height, -maxOffsetY), maxOffsetY)
        
        return CGSize(width: limitedX, height: limitedY)
    }
    
    // 실제 표시되는 이미지 크기 계산
    private func calculateImageSize(for geometry: GeometryProxy, image: UIImage) -> CGSize {
        let imageRatio = image.size.width / image.size.height
        let viewRatio = geometry.size.width / geometry.size.height
        
        if imageRatio > viewRatio {
            let width = geometry.size.width
            let height = width / imageRatio
            return CGSize(width: width, height: height)
        } else {
            let height = geometry.size.height
            let width = height * imageRatio
            return CGSize(width: width, height: height)
        }
    }
    
    private func loadImage() {
        Task {
            if fileName.lowercased().hasSuffix(".jpg") ||
                fileName.lowercased().hasSuffix(".jpeg") ||
                fileName.lowercased().hasSuffix(".png") {
                self.image = await ImageFileManager.shared.loadImage(fileName: fileName)
            } else {
                self.image = UIImage(named: fileName)
            }
        }
    }
}

#Preview("가로 꽉 채우기 (기본)") {
    ZoomableAsyncPhotoImageView(fileName: "sample_image3") { scale in
        print("Scale changed: \(scale)")
    }
    .frame(maxWidth: .infinity)
}

#Preview("전체 이미지 맞춤") {
    ZoomableAsyncPhotoImageView(fileName: "sample_image2") { scale in
        print("Scale changed: \(scale)")
    }
    .frame(height: 300)
}
