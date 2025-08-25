//
//  ArchiveCalendarView.swift
//  PawCut
//
//  Created by taeni on 8/13/25.
//

import SwiftUI

struct ArchiveCalendarView: View {
    @ObservedObject var viewModel: ArchiveViewModel
    @State private var calendarRange: CalendarRange = CalendarRange(startYear: 2025, startMonth: 1, endYear: 2025, endMonth: 12)
    
    @State private var isInitial: Bool = true // 처음에만 scroll 하단
    
    struct CalendarRange {
        let startYear: Int
        let startMonth: Int
        let endYear: Int
        let endMonth: Int
    }
    
    private var thumbnailImages: [Date: String] {
        viewModel.createThumbnailImages()
    }
    
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
    
    // TODO: 제일 오래된 사진 조회 후 가져오기
    private func calendarRange(fromYear: Int, fromMonth: Int) -> (startYear: Int, startMonth: Int, endYear: Int, endMonth: Int) {
        let calendar = Calendar.current
        let today = Date()
        
        let endYear = calendar.component(.year, from: today)
        let endMonth = calendar.component(.month, from: today)
        
        return (startYear: fromYear, startMonth: fromMonth, endYear: endYear, endMonth: endMonth)
    }
}

#Preview {
    let mockViewModel = ArchiveViewModel()
    ArchiveCalendarView(viewModel: mockViewModel)
}
