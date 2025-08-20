//
//  ArchiveGridView.swift
//  PawCut
//
//  Created by taeni on 8/13/25.
//

import SwiftUI

struct ArchiveGridView: View {
    @ObservedObject var viewModel: ArchiveViewModel
    
    // 디바이스별로 width dynamic
    private var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    private var gridWidth: CGFloat {
        (screenWidth - 6) / 3
    }
    
    private var gridHeight: CGFloat {
        gridWidth / 3 * 4
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible(), spacing: 3), count: 3),
                    spacing: 3
                ) {
                    ForEach(viewModel.sortedDates, id: \.self) { date in
                        if let photos = viewModel.groupedPhotos[date] {
                            ForEach(Array(photos.enumerated()), id: \.element.id) { index, photo in
                                PhotoGridCell(
                                    photo: photo,
                                    gridWidth: gridWidth,
                                    gridHeight: gridHeight,
                                    showDateOverlay: index == 0,
                                    onTap: {
                                        viewModel.selectPhoto(photo, at: index, date: date)
                                    }
                                )
                            }
                        }
                    }
                    
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 1)
                        .id("bottom_scroll")
                }
            }
            .onAppear {
                proxy.scrollTo("bottom_scroll", anchor: .bottom)
            }
            .onChange(of: viewModel.groupedPhotos) { _, _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    proxy.scrollTo("bottom_scroll", anchor: .bottom)
                }
            }
        }
    }
}

struct PhotoGridCell: View {
    let photo: Photo
    let gridWidth: CGFloat
    let gridHeight: CGFloat
    let showDateOverlay: Bool
    let onTap: () -> Void
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(.clear)
            
            AsyncPhotoImageView(fileName: photo.fileName)
                .frame(height: gridWidth, alignment: .bottom)
        }
        .frame(width: gridWidth, height: gridHeight)
        .clipped()
        .overlay(
            showDateOverlay ? PhotoDateOverlay(date: photo.createdAt) : nil,
            alignment: .topLeading
        )
        .onTapGesture {
            onTap()
        }
    }
}

struct PhotoDateOverlay: View {
    let date: Date
    
    var body: some View {
        VStack(spacing: 2) {
            PawTitleLabel.semi17(
                date.dayText,
                color: .grayScale01
            )
            
            PawBodyLabel.med8(
                date.monthText,
                color: .grayScale03
            )
        }
        .frame(width: 40, height: 40)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(.grayScale06.opacity(0.85))
        )
        .padding(3)
    }
}

#Preview {
    let mockViewModel = ArchiveViewModel()
    ArchiveGridView(viewModel: mockViewModel)
}
