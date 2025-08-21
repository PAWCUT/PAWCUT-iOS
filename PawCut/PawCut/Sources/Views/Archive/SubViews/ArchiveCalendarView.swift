//
//  ArchiveCalendarView.swift
//  PawCut
//
//  Created by taeni on 8/13/25.
//

import SwiftUI

struct ArchiveCalendarView: View {
    @ObservedObject var viewModel: ArchiveViewModel
    
    // TODO: 추후 생성날짜의 달 ~ 오늘 기준의 달 로 커스텀
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 0) {
                    
                    // TODO: viewModel 또는 사용자 정보에서 최초 생성 연, 월 가져오기
                    let range = calendarRange(fromYear: 2025, fromMonth: 6)
                    
                    PawCalendarView.navigation(
                        from: range.startYear,
                        startMonth: range.startMonth,
                        to: range.endYear,
                        endMonth: range.endMonth,
                        dateImages: viewModel.createThumbnailImages(),
                        onNavigate: { date in
                            viewModel.goToDetails(date: date, index: 0)
                        }
                    )
                    .frame(maxHeight: .infinity)
                    
                    // 맨 아래 기준점
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 1)
                        .id("bottom")
                }
            }
            .onAppear {
                proxy.scrollTo("bottom", anchor: .bottom)
            }
            .onChange(of: viewModel.groupedPhotos) { _, _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    proxy.scrollTo("bottom", anchor: .bottom)
                }
            }
        }
    }
    
    private func calendarRange(fromYear: Int, fromMonth: Int) -> (startYear: Int, startMonth: Int, endYear: Int, endMonth: Int) {
        let calendar = Calendar.current
        let today = Date()
        
        let endYear = calendar.component(.year, from: today)
        let endMonth = calendar.component(.month, from: today)
        
        return (startYear: fromYear, startMonth: fromMonth, endYear: endYear, endMonth: endMonth)
    }
}
