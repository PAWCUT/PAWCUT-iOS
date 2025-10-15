//
//  PhotoDetailsImageGallery.swift
//  PawCut
//
//  Created by taeni on 9/22/25.
//
import SwiftUI

struct PhotoDetailsImageGallery: View {
    let sortedDates: [Date]
    let groupedPhotos: [Date: [Photo]]
    let currentPhoto: Photo?
    
    @Binding var scrollPosition: Photo.ID?
    @Binding var isZoomedIn: Bool
    
    let onPhotoPositionUpdate: (Date, Int) -> Void
    let onSwipeToNext: () -> Void
    let onSwipeToPrevious: () -> Void
    
    private var allPhotos: [Photo] {
        sortedDates.flatMap { date in
            groupedPhotos[date.startOfDay] ?? []
        }
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 0) {
                ForEach(allPhotos, id: \.id) { photo in
                    ZoomableAsyncPhotoImageView(fileName: photo.fileName) { newScale in
                        isZoomedIn = newScale > 1.0
                    }
                    .sideTapNavigationGesture(
                        onTapLeft: {
                            if !isZoomedIn {
                                onSwipeToPrevious()
                            }
                        },
                        onTapRight: {
                            if !isZoomedIn {
                                onSwipeToNext()
                            }
                        },
                        edgeRatio: 0.2
                    )
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
            if let currentPhoto = currentPhoto {
                scrollPosition = currentPhoto.id
            }
        }
        .onChange(of: scrollPosition) { _, newScrollPosition in
            updateViewModelFromScrollPosition(newScrollPosition)
        }
        .onChange(of: currentPhoto) { oldValue, newPhoto in
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
    
    private func updateViewModelFromScrollPosition(_ newScrollPosition: Photo.ID?) {
        guard let photoId = newScrollPosition,
              let photo = allPhotos.first(where: { $0.id == photoId }) else { return }
        
        let newDate = photo.createdAt.startOfDay
        let newIndex = groupedPhotos[newDate]?.firstIndex(where: { $0.id == photoId }) ?? 0
        
        onPhotoPositionUpdate(newDate, newIndex)
    }
}
