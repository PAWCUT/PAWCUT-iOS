//
//  ArchiveGridView.swift
//  PawCut
//
//  Created by taeni on 8/13/25.
//

import SwiftUI

struct ArchiveGridView: View {
    let sortedDates: [Date]
    let groupedPhotos: [Date: [Photo]]
    
    let onPhotoTap: (Date, Int) -> Void
    
    @State private var isInitial: Bool = true
    
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
                    ForEach(sortedDates, id: \.self) { date in
                        if let photos = groupedPhotos[date] {
                            ForEach(Array(photos.enumerated()), id: \.element.id) { index, photo in
                                PhotoGridCell(
                                    photo: photo,
                                    gridWidth: gridWidth,
                                    gridHeight: gridHeight,
                                    showDateOverlay: index == 0,
                                    onTap: {
                                        onPhotoTap(date, index)
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
                willNeedScrollToBottom(proxy: proxy)
            }
        }
    }
    
    private func willNeedScrollToBottom(proxy: ScrollViewProxy) {
        if isInitial {
            proxy.scrollTo("bottom_scroll", anchor: .bottom)
            isInitial = false
        }
    }
}



#Preview {
    let mockViewModel = ArchiveViewModel()
    ArchiveGridView(sortedDates: mockViewModel.sortedDates, groupedPhotos: mockViewModel.groupedPhotos, onPhotoTap: {_,_ in print("Tapped")})
}
