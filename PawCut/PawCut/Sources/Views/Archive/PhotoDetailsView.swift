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
    
    @State private var isZoomedIn: Bool = false
    @State private var scrollPosition: Photo.ID?
    
    init(initialDate: Date, initialIndex: Int) {
        _viewModel = StateObject(wrappedValue: PhotoDetailsViewModel(initialDate: initialDate, initialIndex: initialIndex))
    }
    
    var body: some View {
        ZStack {
            Color.grayScale06.ignoresSafeArea()
            
            VStack(spacing: 0) {
                if !isZoomedIn {
                    PhotoDetailsHeader(
                        currentPhoto: viewModel.currentPhoto,
                        onBackTap: {
                            viewModel.didTapBackButton()
                        }
                    )
                    .padding(.top, 11)
                    .padding(.horizontal)
                    .padding(.bottom, 26)
                }
                
                PhotoDetailsImageGallery(
                    sortedDates: viewModel.sortedDates,
                    groupedPhotos: viewModel.groupedPhotos,
                    currentPhoto: viewModel.currentPhoto,
                    scrollPosition: $scrollPosition,
                    isZoomedIn: $isZoomedIn,
                    onPhotoPositionUpdate: viewModel.didUpdatePhotoPosition,
                    onSwipeToNext: viewModel.didSwipeToNextImage,
                    onSwipeToPrevious: viewModel.didSwipeToPreviousImage
                )
                .padding(.bottom, 20)
                
                if !isZoomedIn {
                    PhotoDetailsThumbnailStrip(
                        currentPhotos: viewModel.currentPhotos,
                        currentPhoto: viewModel.currentPhoto,
                        onThumbnailTap: viewModel.didTapThumbnail
                    )
                    .padding(.bottom, 58)
                    
                    PhotoDetailsBottomControlView(
                        onSaveTap: {
                            viewModel.didTapSavePhoto()
                        },
                        onDeleteTap: {
                            viewModel.didTapDeletePhoto()
                        }
                    )
                    .padding(.horizontal, 45)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.willSetupModelContext(modelContext)
        }
        .toast(
            isShowing: $viewModel.showToast,
            message: viewModel.toastMessage,
            iconName: "toast_icon",
            duration: 2.0
        )
        .pawAlert(
            isShowing: $viewModel.showDeleteConfirmation,
            title: "정말 사진을 삭제할까요?",
            message: "삭제한 사진은 다시 확인할 수 없어요.",
            confirmTitle: "삭제하기",
            cancelTitle: "아니요",
            onConfirm: {
                viewModel.didConfirmDeletePhoto()
            }
        )
    }
}

#Preview {
    PhotoDetailsView(initialDate: Date(), initialIndex: 0)
}
