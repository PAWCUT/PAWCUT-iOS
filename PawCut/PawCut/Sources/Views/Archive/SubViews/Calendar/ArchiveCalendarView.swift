//
//  ArchiveCalendarView.swift
//  PawCut
//
//  Created by taeni on 8/13/25.
//

import SwiftUI

struct ArchiveCalendarView: View {
    let calendarRange: (startYear: Int, startMonth: Int, endYear: Int, endMonth: Int)
    let thumbnailImages: [Date: String]
    
    let onDateNavigate: (Date) -> Void
    
    @State private var isInitial: Bool = true
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 0) {
                    PawCalendarView.navigation(
                        from: calendarRange.startYear,
                        startMonth: calendarRange.startMonth,
                        to: calendarRange.endYear,
                        endMonth: calendarRange.endMonth,
                        dateImages: thumbnailImages,
                        onNavigate: onDateNavigate
                    )
                    .frame(maxHeight: .infinity)
                    
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
    ArchiveCalendarView(calendarRange: mockViewModel.calendarRange, thumbnailImages: mockViewModel.createThumbnailImages(), onDateNavigate: {_ in print("onDateNavigate")})
}
