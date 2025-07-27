//
//  CustomCalendarView.swift
//  PawCut
//
//  Created by taeni on 7/26/25.
//

import SwiftUI

// MARK: - Custom Calendar View
// 🎯 역할: 캘린더 UI를 렌더링하는 SwiftUI View
// 🏗️ 패턴: MVVM의 View - 사용자 인터페이스만 담당
// 📡 특징: @Bindable로 ViewModel과 양방향 바인딩

struct CustomCalendarView: View {
    
    // MARK: - Properties
    @Bindable var viewModel: CustomCalendarViewModel   
    let onDateSelected: ((Date) -> Void)?               // 날짜 선택 시 콜백
    
    // MARK: - Private Properties
    private let weekdaySymbols = ["일", "월", "화", "수", "목", "금", "토"]
    
    // MARK: - Initializer
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
            // 1. 헤더 (월/년 표시 + 네비게이션 버튼)
            headerView
            
            // 2. 요일 표시
            weekdayHeaderView
            
            // 3. 날짜 그리드
            calendarGridView
        }
        .background(viewModel.configuration.appearance.backgroundColor)
    }
    
    // MARK: - Header View
    // 📌 월/년 표시와 이전/다음 달 버튼
    private var headerView: some View {
        HStack {
            // 이전 달 버튼
            Button(action: viewModel.goToPreviousMonth) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(viewModel.canGoToPreviousMonth ?
                        viewModel.configuration.appearance.textColor :
                        viewModel.configuration.appearance.disabledTextColor)
            }
            .disabled(!viewModel.canGoToPreviousMonth)
            
            Spacer()
            
            // 월/년 표시
            Text(viewModel.monthYearString)
                .font(viewModel.configuration.appearance.headerFont)
                .foregroundColor(viewModel.configuration.appearance.textColor)
            
            Spacer()
            
            // 다음 달 버튼
            Button(action: viewModel.goToNextMonth) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(viewModel.canGoToNextMonth ?
                        viewModel.configuration.appearance.textColor :
                        viewModel.configuration.appearance.disabledTextColor)
            }
            .disabled(!viewModel.canGoToNextMonth)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
    
    // MARK: - Weekday Header View
    // 📌 일/월/화/수/목/금/토 표시
    private var weekdayHeaderView: some View {
        HStack(spacing: 0) {
            ForEach(weekdaySymbols, id: \.self) { weekday in
                Text(weekday)
                    .font(FontSet.pretendard(size: ._12, weight: .medium))
                    .foregroundColor(viewModel.configuration.appearance.disabledTextColor)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
    
    // MARK: - Calendar Grid View
    // 📌 42개 날짜를 6x7 그리드로 표시
    private var calendarGridView: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: viewModel.configuration.appearance.spacing), count: 7),
            spacing: viewModel.configuration.appearance.spacing
        ) {
            ForEach(viewModel.daysInMonth) { day in
                CalendarDayView(
                    day: day,
                    configuration: viewModel.configuration,
                    onTap: {
                        // 날짜 선택 처리
                        viewModel.selectDate(day.date)
                        onDateSelected?(day.date)
                    }
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
    }
}

// MARK: - Calendar Day View
// 📌 개별 날짜 셀을 렌더링하는 서브뷰
struct CalendarDayView: View {
    let day: CustomCalendarViewModel.CalendarDay
    let configuration: CustomCalendarConfiguration
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text("\(day.day)")
                .font(configuration.appearance.dayTextFont)
                .foregroundColor(textColor)
                .frame(
                    width: configuration.appearance.cellSize,
                    height: configuration.appearance.cellSize
                )
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: configuration.appearance.cornerRadius))
                .overlay(
                    // 범위 선택 시 중간 영역 표시
                    rangeOverlay,
                    alignment: .center
                )
                .scaleEffect(day.isSelected ? 1.1 : 1.0)  // 선택 시 살짝 확대
                .animation(.easeInOut(duration: 0.1), value: day.isSelected)
        }
        .disabled(day.isDisabled)
        .buttonStyle(PlainButtonStyle())  // 기본 버튼 스타일 제거
    }
    
    // MARK: - Computed Properties
    
    /// 텍스트 색상 계산
    private var textColor: Color {
        if day.isDisabled {
            return configuration.appearance.disabledTextColor
        } else if day.isSelected {
            return configuration.appearance.selectedTextColor
        } else if !day.isCurrentMonth {
            return configuration.appearance.disabledTextColor.opacity(0.5)
        } else if day.isToday {
            return configuration.appearance.primaryColor
        } else {
            return configuration.appearance.textColor
        }
    }
    
    /// 배경 색상 계산
    private var backgroundColor: Color {
        if day.isSelected {
            return configuration.appearance.primaryColor
        } else if day.isHighlighted {
            return configuration.appearance.primaryColor.opacity(0.3)
        } else if day.isInRange {
            return configuration.appearance.primaryColor.opacity(0.2)
        } else {
            return Color.clear
        }
    }
    
    /// 범위 선택 시 중간 영역 오버레이
    private var rangeOverlay: some View {
        Group {
            if day.isInRange {
                Rectangle()
                    .fill(configuration.appearance.primaryColor.opacity(0.1))
                    .frame(height: configuration.appearance.cellSize)
            }
        }
    }
}

// MARK: - Convenience Initializers
extension CustomCalendarView {
    
    /// 기본 설정으로 캘린더 생성
    static func `default`(onDateSelected: ((Date) -> Void)? = nil) -> CustomCalendarView {
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
    
    /// 날짜 범위 설정으로 캘린더 생성
    static func withDateRange(
        from startYear: Int,
        to endYear: Int,
        onDateSelected: ((Date) -> Void)? = nil
    ) -> CustomCalendarView {
        let config = CustomCalendarConfiguration(
            displayRange: .years(from: startYear, to: endYear)
        )
        let viewModel = CustomCalendarViewModel(configuration: config)
        return CustomCalendarView(viewModel: viewModel, onDateSelected: onDateSelected)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        // 1. 기본 캘린더
        CustomCalendarView.default { date in
            print("선택된 날짜: \(date)")
        }
        
        Divider()
        
        // 2. 범위 선택 캘린더
        CustomCalendarView.custom(
            configuration: CustomCalendarConfiguration(
                selectionMode: .range,
                displayRange: .years(from: 2020, to: 2030)
            )
        ) { date in
            print("범위 선택: \(date)")
        }
    }
    .padding()
}
