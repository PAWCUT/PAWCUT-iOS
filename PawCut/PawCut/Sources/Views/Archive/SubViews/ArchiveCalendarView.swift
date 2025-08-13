//
//  ArchiveCalendarView.swift
//  PawCut
//
//  Created by taeni on 8/13/25.
//

import SwiftUI

struct ArchiveCalendarView: View {
    @ObservedObject var viewModel: ArchiveViewModel
    
    // TODO: 추후 생성날짜의 달 ~ 마지막 사진생성일자의 달 로 커스텀
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                PawCalendarView.navigation(
                    from: 2024, startMonth: 1,
                    to: 2025, endMonth: 12,
                    dateImages: viewModel.createThumbnailImages(),
                    onNavigate: { date in
                        viewModel.selectCalendarDate(date)
                    }
                )
                .frame(height: 700)
            }
        }
    }
}
