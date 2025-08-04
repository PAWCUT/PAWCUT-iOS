//
//  CustomCalendarView.swift
//  PawCut
//
//  Created by taeni on 7/26/25.
//

import SwiftUI

struct CustomCalendarView: View {
    
    @Bindable var viewModel: CustomCalendarViewModel
    
    let onDateSelected: ((Date) -> Void)?               // 날짜 선택 시
    
    private let weekdaySymbols = ["일", "월", "화", "수", "목", "금", "토"]
    
    init(
        viewModel: CustomCalendarViewModel,
        onDateSelected: ((Date) -> Void)? = nil
    ) {
        self.viewModel = viewModel
        self.onDateSelected = onDateSelected
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        ForEach(Array(viewModel.monthOffsetRange), id: \.self) { monthOffset in
                            monthView(for: monthOffset)
                                .id(monthOffset)
                        }
                    }
                }
                .onAppear {
                    // 초기 스크롤 위치 설정
                    DispatchQueue.main.async {
                        proxy.scrollTo(viewModel.scrollPosition, anchor: .top)
                    }
                }
                .onChange(of: viewModel.scrollPosition) { _, newPosition in
                    // 스크롤 위치 변경 시 애니메이션과 함께 이동
                    withAnimation(.easeInOut(duration: 0.3)) {
                        proxy.scrollTo(newPosition, anchor: .top)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .background(viewModel.configuration.appearance.backgroundColor)
    }
    
    // MARK: - Weekday Header View
    private var weekdayHeaderView: some View {
        HStack(spacing: 0) {
            ForEach(weekdaySymbols, id: \.self) { weekday in
                Text(weekday)
                    .font(viewModel.configuration.appearance.weekdayFont)
                    .multilineTextAlignment(.center)
                    .foregroundColor(viewModel.configuration.appearance.weekColor)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 10)
    }
    
    // MARK: - Month View
    private func monthView(for monthOffset: Int) -> some View {
        let days = viewModel.generateDaysForMonth(offset: monthOffset)
        
        return VStack(spacing: 0) {
            // 월 헤더
            monthHeaderView(for: monthOffset)
            
            // 주 헤더
            weekdayHeaderView
                .background(viewModel.configuration.appearance.backgroundColor)
            
            // 날짜 그리드 - 동적 크기 조정
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible()), count: 7)
            ) {
                ForEach(days) { day in
                    CalendarDayView(
                        day: day,
                        configuration: viewModel.configuration,
                        onTap: {
                            viewModel.selectDate(day.date)
                            onDateSelected?(day.date)
                        }
                    )
                    .frame(width: 40)
                }
            }
            .padding(.bottom, 20)
        }
    }
    
    private func monthHeaderView(for monthOffset: Int) -> some View {
        HStack {
            Text(viewModel.monthYearString(for: monthOffset))
                .font(viewModel.configuration.appearance.headerFont)
                .foregroundColor(viewModel.configuration.appearance.dayColor)
            
            Spacer()
        }.padding(.vertical, 20)
    }
}

struct CalendarDayView: View {
    let day: CustomCalendarViewModel.CalendarDay
    let configuration: CustomCalendarConfiguration
    let onTap: () -> Void
    
    var body: some View {
        
        if !day.isCurrentMonth {
            Color.clear
                .frame(minHeight: 45)
        } else {
            Button(action: {
                if !day.isDisabled {
                    onTap()
                }
            }) {
                ZStack {
                    // Mock 사진 배경 (사진이 있는 경우)
                    if day.hasImage {
                        // Mock 이미지 표시 (실제 파일 대신 그라디언트)
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.blue.opacity(0.6), .purple.opacity(0.6)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(
                                width: configuration.appearance.cellSize,
                                height: configuration.appearance.cellSize
                            )
                            .overlay(
                                Circle()
                                    .stroke(
                                        day.isToday ? configuration.appearance.todayColor : .clear,
                                        lineWidth: day.isToday ? 2 : 0
                                    )
                            )
                            .overlay(
                                // 사진 위에 날짜 숫자 표시
                                Text("\(day.day)")
                                    .font(configuration.appearance.dayTextFont)
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.7), radius: 1, x: 0, y: 1),
                                alignment: .center
                            )
                    } else {
                        // 사진이 없는 경우 기본 날짜 표시
                        ZStack {
                            // 범위 선택 배경 (중간 영역)
                            if day.isInRange {
                                Rectangle()
                                    .fill(configuration.appearance.rangeBackgroundColor)
                                    .frame(maxHeight: configuration.appearance.cellSize)
                            }
                            
                            // 범위 선택 반원 처리 (시작일/종료일)
                            if day.isStartDate || day.isEndDate {
                                rangePartialBackground
                            }
                            
                            // 선택된 날짜 배경
                            if day.isSelected {
                                Circle()
                                    .fill(configuration.appearance.primaryColor)
                                    .frame(width: configuration.appearance.cellSize,
                                           height: configuration.appearance.cellSize)
                            }
                            
                            // 오늘 날짜 테두리
                            if day.isToday && !day.isSelected {
                                Circle()
                                    .stroke(configuration.appearance.todayColor, lineWidth: 2)
                                    .frame(width: configuration.appearance.cellSize,
                                           height: configuration.appearance.cellSize)
                            }
                            
                            // 날짜 텍스트
                            Text("\(day.day)")
                                .font(configuration.appearance.dayTextFont)
                                .foregroundColor(textColor)
                        }
                    }
                }
            }
            .frame(minHeight: 45)  // 최소 높이 보장
            .buttonStyle(PlainButtonStyle())
            .disabled(day.isDisabled)
            .opacity(day.isDisabled ? 0.3 : 1.0)
        }
    }
    
    /// 텍스트 색상
    private var textColor: Color {
        if day.isDisabled {
            return configuration.appearance.disabledTextColor
        } else if day.isSelected {
            return configuration.appearance.selectedTextColor
        } else if day.isInRange {
            return configuration.appearance.dayColor
        }  else if day.hasImage {
            return configuration.appearance.selectedTextColor
        } else {
            let weekday = Calendar.current.component(.weekday, from: day.date)
            if weekday == 1 { // 일요일도 검정색
                return configuration.appearance.dayColor
            } else {
                return configuration.appearance.dayColor
            }
        }
    }
    
    /// 범위 선택 시 부분 배경 (시작일/종료일용)
    private var rangePartialBackground: some View {
        Group {
            if configuration.selectionMode == .range && (day.isStartDate || day.isEndDate) {
                let leftColor: Color = day.isStartDate ? .clear : configuration.appearance.rangeBackgroundColor
                let rightColor: Color = day.isEndDate ? .clear : configuration.appearance.rangeBackgroundColor
                
                HStack(spacing: 0) {
                    leftColor.frame(maxWidth: .infinity)
                    rightColor.frame(maxWidth: .infinity)
                }
                .frame(maxHeight: configuration.appearance.cellSize)
            }
        }
    }
}

extension CustomCalendarView {
    
    /// 기본 설정으로 캘린더 생성
    static func defaultCalendar(onDateSelected: ((Date) -> Void)? = nil) -> CustomCalendarView {
        let viewModel = CustomCalendarViewModel()
        return CustomCalendarView(viewModel: viewModel, onDateSelected: onDateSelected)
    }
    
    /// 커스텀 설정으로 캘린더 생성
    static func custom(
        configuration: CustomCalendarConfiguration,
        onDateSelected: ((Date) -> Void)? = nil
    ) -> CustomCalendarView {
        let viewModel = CustomCalendarViewModel(configuration: configuration)
        return CustomCalendarView(viewModel: viewModel, onDateSelected: onDateSelected)
    }
    
    /// 특정 기간 설정으로 캘린더 생성
    static func withDateRange(
        from startYear: Int, startMonth: Int,
        to endYear: Int, endMonth: Int,
        selectionMode: CustomCalendarConfiguration.SelectionMode = .single,
        onDateSelected: ((Date) -> Void)? = nil
    ) -> CustomCalendarView {
        let config = CustomCalendarConfiguration(
            selectionMode: selectionMode,
            displayRange: .months(from: startYear, startMonth: startMonth,
                                  to: endYear, endMonth: endMonth)
        )
        let viewModel = CustomCalendarViewModel(configuration: config)
        return CustomCalendarView(viewModel: viewModel, onDateSelected: onDateSelected)
    }
    
    /// 네비게이션 모드 캘린더 생성 (사진이 있는 날짜 표시)
    static func navigation(
        from startYear: Int, startMonth: Int,
        to endYear: Int, endMonth: Int,
        dateImages: [Date: String] = [:],
        onNavigate: @escaping (Date) -> Void
    ) -> CustomCalendarView {
        let config = CustomCalendarConfiguration.navigationMode(
            from: startYear, startMonth: startMonth,
            to: endYear, endMonth: endMonth,
            dateImages: dateImages,
            onNavigate: onNavigate
        )
        let viewModel = CustomCalendarViewModel(configuration: config)
        return CustomCalendarView(viewModel: viewModel)
    }
}

#Preview {
    VStack {
        // Mock 데이터로 사진이 있는 날짜들 생성
        let mockDateImages: [Date: String] = {
            let calendar = Calendar.current
            var images: [Date: String] = [:]
            
            // 오늘부터 지난 10일간 랜덤하게 사진 배치
            for i in 0..<30 {
                if Bool.random() { // 50% 확률로 사진 있음
                    let date = calendar.date(byAdding: .day, value: -i, to: Date())!
                    let normalizedDate = calendar.startOfDay(for: date)
                    images[normalizedDate] = "mock_photo_\(i).jpg"
                }
            }
            return images
        }()
        
        let config = CustomCalendarConfiguration(
            selectionMode: .navigate,
            appearance: .pawCutTheme,
            displayRange: .months(from: 2025, startMonth: 1, to: 2027, endMonth: 8),
            dateImages: mockDateImages,
            onNavigate: { date in
                print("선택된222 날짜: \(date)")
            }
        )
        
        let viewModel = CustomCalendarViewModel(configuration: config)
        
        CustomCalendarView(viewModel: viewModel)
            .frame(height: .infinity)
    }
}
