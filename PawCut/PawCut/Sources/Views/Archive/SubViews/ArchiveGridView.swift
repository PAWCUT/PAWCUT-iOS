//
//  ArchiveGridView.swift
//  PawCut
//
//  Created by taeni on 8/13/25.
//

import SwiftUI

struct ArchiveGridView: View {
    @ObservedObject var viewModel: ArchiveViewModel
    
    @State private var isInitial: Bool = true // 처음에만 scroll 하단
    
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
                                        viewModel.goToDetails(date: date, index: index)
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
                if isInitial {
                    proxy.scrollTo("bottom_scroll", anchor: .bottom)
                    isInitial = false
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
            Color.clear
            
            AsyncPhotoImageView(fileName: photo.fileName)
                .scaledToFill()
                .frame(width: gridWidth, height: gridHeight, alignment: .bottom)
                .clipped()
        }
        .frame(width: gridWidth, height: gridHeight)
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
