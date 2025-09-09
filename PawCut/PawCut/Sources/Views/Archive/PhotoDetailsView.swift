//
//  PhotoDetailsView.swift
//  PawCut
//
//  Created by taeni on 8/17/25.
//

import SwiftUI

struct PhotoDetailsView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: PhotoDetailsViewModel
    @StateObject private var navigationManager = NavigationManager.shared
    
    @State private var isZoomedIn: Bool = false
    
    // 스크롤 위치 추적
    @State private var scrollPosition: Photo.ID?
    
    // 전체 사진
    private var allPhotos: [Photo] {
        viewModel.sortedDates.flatMap { date in
            viewModel.groupedPhotos[date.startOfDay] ?? []
        }
    }
    
    init(initialDate: Date, initialIndex: Int) {
        _viewModel = StateObject(wrappedValue: PhotoDetailsViewModel(initialDate: initialDate, initialIndex: initialIndex))
    }
    
    var body: some View {
        ZStack {
            Color.grayScale06.ignoresSafeArea()
            
            VStack(spacing: 0) {
                if !isZoomedIn {
                    headerView
                        .padding(.top, 11)
                        .padding(.horizontal)
                        .padding(.bottom, 26)
                }
                
                imageGalleryView
                    .padding(.bottom, 20)
                
                if !isZoomedIn {
                    ThumbnailStripView(viewModel: viewModel)
                        .padding(.bottom, 58)
                    
                    bottomControlsView
                        .padding(.horizontal, 45)
                        .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            setupViewModel()
        }
        .toast(isShowing: $viewModel.showToast, message: viewModel.toastMessage, iconName: "toast_icon", duration: 2.0)
        .pawAlert(
            isShowing: $viewModel.showDeleteConfirmation,
            title: "정말 사진을 삭제할까요?",
            message: "삭제한 사진은 다시 확인할 수 없어요.",
            confirmTitle: "삭제하기",
            cancelTitle: "아니요",
            onConfirm: {
                viewModel.deleteCurrentImage()
            }
        )
    }
    
    private var imageGalleryView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 0) {
                ForEach(allPhotos, id: \.id) { photo in
                    ZoomableAsyncPhotoImageView(fileName: photo.fileName) { newScale in
                        isZoomedIn = newScale > 1.0
                    }
                    .aspectRatio(contentMode: .fit)
                    .sideTapNavigationGesture(onTapLeft: {
                        if !isZoomedIn {
                            moveToPreviousImage()
                        }
                    }, onTapRight: {
                        if !isZoomedIn {
                            moveToNextImage()
                        }
                    }, edgeRatio: 0.2)
                    .containerRelativeFrame(.horizontal)
                    .id(photo.id)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $scrollPosition)
        .scrollDisabled(isZoomedIn)
        .onAppear {
            if let currentPhoto = viewModel.currentPhoto {
                scrollPosition = currentPhoto.id
            }
        }
        .onChange(of: scrollPosition) { _, newScrollPosition in
            updateViewModelFromScrollPosition(newScrollPosition)
        }
        .onChange(of: viewModel.currentPhoto) { oldValue, newPhoto in
            if let newPhoto = newPhoto, scrollPosition != newPhoto.id {
                if oldValue == nil {
                    scrollPosition = newPhoto.id
                } else {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        scrollPosition = newPhoto.id
                    }
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.grayScale01)
            }
            Spacer()
        }
        .overlay(
            VStack {
                if let photo = viewModel.currentPhoto {
                    PawTitleLabel.semi16(
                        photo.createdAt.koreanMonthDateString,
                        color: .grayScale01
                    )
                }
            }
        )
    }
    
    private var bottomControlsView: some View {
        HStack {
            Button(action: {
                viewModel.saveCurrentImage()
            }) {
                ImageComponent(imageName: "download_icon", size: CGSize(width: 20, height: 24))
                    .background(
                        Circle()
                            .fill(Color.grayBackground)
                            .frame(width: 45, height: 45)
                    )
            }
            
            Spacer()
            
            Button(action: {
                viewModel.showDeleteConfirmation = true
            }) {
                ImageComponent(imageName: "trash_icon", size: CGSize(width: 20, height: 23))
                    .background(
                        Circle()
                            .fill(Color.grayBackground)
                            .frame(width: 45, height: 45)
                    )
            }
        }
    }
    
    private func updateViewModelFromScrollPosition(_ newScrollPosition: Photo.ID?) {
        guard let photoId = newScrollPosition,
              let photo = allPhotos.first(where: { $0.id == photoId }) else { return }
        
        let newDate = photo.createdAt.startOfDay
        let newIndex = viewModel.groupedPhotos[newDate]?.firstIndex(where: { $0.id == photoId }) ?? 0
        
        viewModel.currentDate = newDate
        viewModel.currentIndex = newIndex
    }
    
    private func moveToPreviousImage() {
        if let currentPhoto = viewModel.currentPhoto,
           let currentAllIndex = allPhotos.firstIndex(where: { $0.id == currentPhoto.id }),
           currentAllIndex > 0 {
            let previousPhoto = allPhotos[currentAllIndex - 1]
            let previousDate = previousPhoto.createdAt.startOfDay
            let previousIndexInDate = viewModel.groupedPhotos[previousDate]?.firstIndex(where: { $0.id == previousPhoto.id }) ?? 0
            
            viewModel.currentDate = previousDate
            viewModel.currentIndex = previousIndexInDate
        }
    }
    
    private func moveToNextImage() {
        if let currentPhoto = viewModel.currentPhoto,
           let currentAllIndex = allPhotos.firstIndex(where: { $0.id == currentPhoto.id }),
           currentAllIndex < allPhotos.count - 1 {
            let nextPhoto = allPhotos[currentAllIndex + 1]
            let nextDate = nextPhoto.createdAt.startOfDay
            let nextIndexInDate = viewModel.groupedPhotos[nextDate]?.firstIndex(where: { $0.id == nextPhoto.id }) ?? 0
            
            viewModel.currentDate = nextDate
            viewModel.currentIndex = nextIndexInDate
        }
    }
    
    private func setupViewModel() {
        viewModel.setupModelContext(modelContext)
    }
}

#Preview {
    PhotoDetailsView(initialDate: Date(), initialIndex: 0)
}

