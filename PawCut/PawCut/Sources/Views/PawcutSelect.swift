//
//  select.swift
//  PawCut
//
//  Created by Jay on 7/28/25.
//

import SwiftUI

struct PawcutSelectionView: View {
    @State private var selectedImages: [UIImage] = []
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.grayScale01)
                }
                .frame(width: 33, height: 44)
                
                Spacer()
            }
            
            // 상단 이미지 프레임 미리보기
            VStack {
                GridImagePreview(images: selectedImages)
                    .frame(width: 225, height: 340)
                    .overlay(
                        Rectangle()
                            .stroke(Color("GrayScale01Color"), lineWidth: 1)
                    )
                
                Image("pawcut_logo") // 아래 Pawcut 로고
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
                
            }
            .padding(.top, 38)
            

            // 사진 선택 카운트
            HStack {
                Text("사진 선택하기")
                    .font(.system(size: 16, weight: .semibold))
                Text("(\(selectedImages.count)/4)")
                    .foregroundColor(.purple)
                    .font(.system(size: 16, weight: .semibold))
            }
            .padding(.top, 12)

            // 선택된 사진 썸네일
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(0..<4, id: \.self) { index in
                        if index < selectedImages.count {
                            Image(uiImage: selectedImages[index])
                                .resizable()
                                .scaledToFill()
                                .frame(width: 64, height: 90)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        } else {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 64, height: 90)
                        }
                    }
                }
                .padding(.horizontal)
            }

            Spacer()

            // 다음 버튼
            Button(action: {
                // 다음 단계로 이동
            }) {
                Text("다음")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color.gray)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
            .padding(.bottom, 32)
        }
        .navigationTitle("포우컷 선택")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    // 뒤로 가기
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            }
        }
    }
}

struct GridImagePreview: View {
    let images: [UIImage]

    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            let spacing: CGFloat = 4
            let cellSize = (size.width - spacing) / 2
            
            VStack(spacing: spacing) {
                ForEach(0..<2, id: \.self) { row in
                    HStack(spacing: spacing) {
                        ForEach(0..<2, id: \.self) { col in
                            let index = row * 2 + col
                            if index < images.count {
                                Image(uiImage: images[index])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: cellSize, height: cellSize)
                                    .clipped()
                            } else {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: cellSize, height: cellSize)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    PawcutSelectionView()
}




