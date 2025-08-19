//
//  AsyncPhotoImageView.swift
//  PawCut
//
//  Created by taeni on 8/13/25.
//

import SwiftUI

struct AsyncPhotoImageView: View {
    let fileName: String
    var isZoomEnabled: Bool = true
    var contentMode: ContentMode = .fill
    
    @State private var image: UIImage?
    @State private var scale: CGFloat = 1.0
    @State private var lastScaleValue: CGFloat = 1.0
    @State private var doubleTapZoomScale: CGFloat = 2.5
    
    private let defaultImage = Image("empty_image") // default iamge
    
    var body: some View {
        Group {
            if let image = image {
                imageContent(image: image)
            } else {
                loadingContent
            }
        }
        .onAppear {
            loadImage()
        }
        .onChange(of: fileName) { _, _ in
            loadImage()
        }
    }
    
    private func imageContent(image: UIImage) -> some View {
        let imageView = Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: contentMode)
            .scaleEffect(scale)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
        
        if isZoomEnabled {
            return AnyView(
                imageView
                    .doubleTapZoomGesture(
                        scale: $scale,
                        defaultScale: 1.0,
                        zoomScale: doubleTapZoomScale
                    )
                    .pinchZoomGesture(
                        scale: $scale,
                        lastScaleValue: $lastScaleValue,
                        minScale: 1.0,
                        maxScale: 5.0
                    )
            )
        } else {
            return AnyView(imageView)
        }
    }
    
    private var loadingContent: some View {
        defaultImage
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(maxWidth: .infinity)
            .clipped()
            .overlay(
                // 로딩 인디케이터
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color(.grayScale03)))
                    .scaleEffect(1.2)
            )
    }
    
    private func loadImage() {
        // 줌 상태 초기화
        scale = 1.0
        lastScaleValue = 1.0
        image = nil
        
        // TODO: - ImageFileManager 사용 아래 loadMockImage 는 제거
        /*
        ImageFileManager....
        */
        
        // MARK: - 임시 구현 (실제 구현 시 위 주석 해제하고 아래 제거)
        loadMockImage()
    }
    
    private func loadMockImage() {
        // 실제 앱에서는 ImageFileManager를 사용하지만,
        // 현재는 주석처리된 상태이므로 샘플 이미지를 사용
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            // fileName에서 .jpg 확장자 제거하고 Asset 이미지명으로 사용
            let imageName = self.fileName.replacingOccurrences(of: ".jpg", with: "")
            
            if let uiImage = UIImage(named: imageName) {
                self.image = uiImage
            } else {
                // 샘플 이미지가 없으면 빈 이미지 사용
                self.image = UIImage(named: "empty_image")
            }
        }
    }
}

extension AsyncPhotoImageView {
    /// 가로 꽉 채우면서 비율 유지 (기본값)
    static func fillWidth(fileName: String, isZoomEnabled: Bool = true) -> AsyncPhotoImageView {
        AsyncPhotoImageView(fileName: fileName, isZoomEnabled: isZoomEnabled, contentMode: .fill)
    }
    
    /// 전체 이미지가 보이도록 맞춤 (여백 생길 수 있음)
    static func fitContent(fileName: String, isZoomEnabled: Bool = true) -> AsyncPhotoImageView {
        AsyncPhotoImageView(fileName: fileName, isZoomEnabled: isZoomEnabled, contentMode: .fit)
    }
    
    /// 썸네일용 (정사각형으로 크롭)
    static func thumbnail(fileName: String) -> AsyncPhotoImageView {
        AsyncPhotoImageView(fileName: fileName, isZoomEnabled: false, contentMode: .fill)
    }
}

#Preview("가로 꽉 채우기 (기본)") {
    AsyncPhotoImageView.fillWidth(fileName: "sample_image2.jpg")
        .frame(height: 300)
}

#Preview("전체 이미지 맞춤") {
    AsyncPhotoImageView.fitContent(fileName: "sample_image2.jpg")
        .frame(height: 300)
}

#Preview("썸네일 크기") {
    HStack {
        AsyncPhotoImageView.thumbnail(fileName: "sample_image1.jpg")
            .frame(width: 22, height: 32)
        
        AsyncPhotoImageView.thumbnail(fileName: "sample_image2.jpg")
            .frame(width: 32, height: 32)
        
        AsyncPhotoImageView.thumbnail(fileName: "sample_image3.jpg")
            .frame(width: 22, height: 32)
    }
    .padding()
}

#Preview("줌 비활성화") {
    AsyncPhotoImageView(fileName: "sample_image2.jpg", isZoomEnabled: false, contentMode: .fill)
        .frame(height: 200)
}

