//
//  AsyncPhotoImageView.swift
//  PawCut
//
//  Created by taeni on 8/13/25.
//

import SwiftUI

struct AsyncPhotoImageView: View {
    
    // UIImage 를 가져옴
    let fileName: String
    
    @State private var image: UIImage?
    @State private var isLoading = true
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if isLoading {
                // 테스트용 이미지 보기
                 ImageComponent(imageName: "mock_sample", size: CGSize(width: 290, height: 440))
                
                // TODO: Loading 이미지 필요?
                
                //                ProgressView()
                //                    .scaleEffect(0.8)
                //                    .foregroundColor(.grayScale03)
            } else {
                // TODO: Loading 이미지 필요?
                ImageComponent(imageName: "mock_sample", size: CGSize(width: 290, height: 440))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.grayScale05)
    }
}

#Preview {
    AsyncPhotoImageView(fileName: "mock_template")
}
