//
//  AsyncPhotoImageView.swift
//  PawCut
//
//  Created by taeni on 8/13/25.
//

import SwiftUI

struct AsyncPhotoImageView: View {
    let fileName: String
    private let imageFileManager = ImageFileManager.shared
    
    // 애셋 이미지 사용을 위한 초기화
    init(assetName: String) {
        self.fileName = assetName
    }
    
    // 파일명 이미지 사용을 위한 초기화
    init(fileName: String) {
        self.fileName = fileName
    }
    
    @State private var image: UIImage?
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                Image("empty_image")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.grayScale06)
            }
        }
        .onAppear {
            loadImage()
        }
        .onChange(of: fileName) { _, _ in
            loadImage()
        }
    }
    
    private func loadImage() {
        Task {
            // 파일명에 ".jpg"가 포함되어 있으면 파일 시스템에서 로드, 아니면 애셋에서 로드
            if fileName.lowercased().hasSuffix(".jpg") || fileName.lowercased().hasSuffix(".jpeg") || fileName.lowercased().hasSuffix(".png") {
                self.image = await imageFileManager.loadImage(fileName: fileName)
            } else {
                self.image = UIImage(named: fileName)
            }
        }
    }
}

#Preview("가로 꽉 채우기 (기본)") {
    AsyncPhotoImageView(assetName: "sample_image2")
        .frame(maxWidth: .infinity)
}

#Preview("전체 이미지 맞춤") {
    AsyncPhotoImageView(assetName: "sample_image2")
        .frame(height: 300)
}

#Preview("썸네일 크기") {
    HStack {
        AsyncPhotoImageView(assetName: "sample_image1")
            .frame(width: 22, height: 32)
            .border(.red)
        
        AsyncPhotoImageView(assetName: "sample_image2")
            .scaledToFill()
            .frame(width: 32, height: 32)
            .clipped()
        
        AsyncPhotoImageView(assetName: "sample_image3")
            .frame(width: 22, height: 32)
            .border(.red)
    }
    .padding()
}

