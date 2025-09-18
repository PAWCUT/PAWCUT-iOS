//
//  ThumbnailStripView.swift
//  PawCut
//
//  Created by taeni on 8/21/25.
//

import SwiftUI
import SwiftData

struct ThumbnailStripView: View {
    // TODO: Bye
    @ObservedObject var viewModel: PhotoDetailsViewModel
    @State private var lastHapticIndex: Int = 0 // 마지막 햅틱이 발생한 인덱스
    
    // MARK: - Haptic Manager
    // TODO: 매니저는 ViewModel에서 쓰기로 합의 봄
    private let hapticManager = HapticManager.shared
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 3) {
                    ForEach(viewModel.currentPhotos, id: \.id) { photo in
                        thumbnailCell(for: photo)
                            .id(photo.id)
                    }
                }
                .frame(minWidth: UIScreen.main.bounds.width)
                .padding(.horizontal)
            }
            .frame(height: 32)
            .onAppear {
                scrollToCurrentPhoto(proxy: proxy)
            }
            .onChange(of: viewModel.currentIndex) { _, _ in
                // 썸네일 스크롤 시 햅틱 피드백 추가
                hapticManager.triggerScrollIndexChange(
                    currentIndex: viewModel.currentIndex,
                    lastHapticIndex: &lastHapticIndex
                )
                scrollToCurrentPhoto(proxy: proxy)
            }
            .onChange(of: viewModel.currentDate) { _, _ in
                scrollToCurrentPhoto(proxy: proxy)
            }
        }
    }
    
    private func thumbnailCell(for photo: Photo) -> some View {
        let isSelected = photo.id == viewModel.currentPhoto?.id
        
        return AsyncPhotoImageView(assetName: photo.fileName)
            .scaledToFill()
            .frame(width: isSelected ? 32 : 22, height: 32)
            .clipped()
            .overlay(
                RoundedRectangle(cornerRadius: 3)
                    .foregroundColor(.clear)
            )
            .onTapGesture {
                // TODO: 분리
                if let index = viewModel.currentPhotos.firstIndex(where: { $0.id == photo.id }) {
                    // 썸네일 탭 시 햅틱 피드백 추가
                    hapticManager.triggerSelection()
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

// MARK: - Preview

#Preview {
    let mockPhotos = Photo.mockPhotos
    let groupedPhotos = Dictionary(grouping: mockPhotos) { $0.createdAt.startOfDay }
    
    let viewModel = PhotoDetailsViewModel()
    viewModel.groupedPhotos = groupedPhotos
    viewModel.currentDate = groupedPhotos.keys.sorted(by: >).first ?? Date()
    viewModel.currentIndex = 2 // 미리보기용 초기 인덱스 설정
    
    return ThumbnailStripView(viewModel: viewModel)
}
