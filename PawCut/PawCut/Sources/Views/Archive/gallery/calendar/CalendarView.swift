//
//  CalendarView.swift
//  PawCut
//
//  Created by taeni on 7/27/25.
//

import SwiftUI

struct PhotoGridView: View {
    @Bindable var viewModel: ArchiveViewModel
    
    var body: some View {
        GeometryReader { geometry in
            let gridWidth = (geometry.size.width - 44) / 3
            
            ScrollView {
                LazyVGrid(
                    columns: Array(repeating: GridItem(.fixed(gridWidth), spacing: 2), count: 3),
                    spacing: 2
                ) {
                    ForEach(viewModel.sortedDates, id: \.self) { date in
                        if let photos = viewModel.groupedPhotos[date] {
                            ForEach(Array(photos.enumerated()), id: \.element.id) { index, photo in
                                PhotoGridCell(
                                    photo: photo,
                                    gridWidth: gridWidth,
                                    showDateOverlay: index == 0,
                                    date: date,
                                    onTap: { viewModel.selectPhoto(photo) }
                                )
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
        }
    }
}
