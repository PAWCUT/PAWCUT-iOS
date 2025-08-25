//
//  ArchiveCalendarView.swift
//  PawCut
//
//  Created by taeni on 8/13/25.
//

import SwiftUI

struct ArchiveCalendarView: View {
    @ObservedObject var viewModel: ArchiveViewModel
    @State private var isInitial: Bool = true // 처음에만 scroll 하단
    
    private var thumbnailImages: [Date: String] {
        viewModel.createThumbnailImages()
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 0) {
                    PawCalendarView.navigation(
                        from: viewModel.calendarRange.startYear,
                        startMonth: viewModel.calendarRange.startMonth,
                        to: viewModel.calendarRange.endYear,
                        endMonth: viewModel.calendarRange.endMonth,
                        dateImages: thumbnailImages,
                        onNavigate: { date in
                            if thumbnailImages.keys.contains(date)  {
                                viewModel.goToDetails(date: date, index: 0)
                            }
                        }
                    )
                    .frame(maxHeight: .infinity)
                    
                    // 맨 아래 기준점
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

#Preview {
    let mockViewModel = ArchiveViewModel()
    ArchiveCalendarView(viewModel: mockViewModel)
}
