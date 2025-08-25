//
//  ThumbnailStripView.swift
//  PawCut
//
//  Created by taeni on 8/20/25.
//

import SwiftUI

struct ThumbnailStripView: View {
    @ObservedObject var viewModel: PhotoDetailsViewModel
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 3) {
                    ForEach(viewModel.currentPhotos, id: \.id) { photo in
                        thumbnailCell(for: photo)
                            .id(photo.id)
                    }
                }
                .padding(.horizontal) // 썸네일 스트립 시작/끝에 여백 추가
            }
            .frame(height: 32) // 썸네일 스트립 높이 고정
            .onAppear {
                scrollToCurrentPhoto(proxy: proxy)
            }
            .onChange(of: viewModel.currentIndex) { _, _ in
                scrollToCurrentPhoto(proxy: proxy)
            }
            .onChange(of: viewModel.currentDate) { _, _ in
                scrollToCurrentPhoto(proxy: proxy)
            }
        }
    }
    
    private func thumbnailCell(for photo: Photo) -> some View {
        // 현재 선택된 사진의 ID와 비교
        let isSelected = photo.id == viewModel.currentPhoto?.id
        
        return AsyncPhotoImageView(fileName: photo.fileName)
            .scaledToFill()
            .frame(width: isSelected ? 32 : 22, height: 32)
            .clipped()
            .overlay(
                // 선택된 썸네일에 하이라이트 표시
                RoundedRectangle(cornerRadius: 3)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
            .onTapGesture {
                if let index = viewModel.currentPhotos.firstIndex(where: { $0.id == photo.id }) {
                    viewModel.currentIndex = index
                }
            }
    }
    
    private func scrollToCurrentPhoto(proxy: ScrollViewProxy) {
        if let currentPhoto = viewModel.currentPhoto {
            withAnimation(.easeInOut(duration: 0.3)) {
                proxy.scrollTo(currentPhoto.id, anchor: .center)
            }
        }
    }
}
