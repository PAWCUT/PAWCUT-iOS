//
//  CustomCalendarViewModel.swift
//  PawCut
//
//  Created by taeni on 7/26/25.
//

import SwiftUI
import Foundation
import Observation

@Observable
class CustomCalendarViewModel {
    
    // MARK: - Public Properties
    var selectedDate: Date?                                     // 선택된 단일 날짜
    var selectedRange: CustomCalendarConfiguration.DateRange? // 선택된 날짜 범위
    var selectedDates: Set<Date> = []                          // 선택된 여러 날짜들
    var scrollPosition: Int = 0                                // 현재 스크롤 위치 (월 오프셋)
    
    // MARK: - Private Properties
    private let calendar = Calendar.current                     // 날짜 계산용 캘린더
    var configuration: CustomCalendarConfiguration            // 설정값들
    
    // MARK: - Computed Properties
    
    /// 표시할 월 오프셋 범위 (Configuration의 DisplayRange 기반으로 계산)
    var monthOffsetRange: ClosedRange<Int> {
        let displayRange = configuration.effectiveDisplayRange
        let startOffset = displayRange.startMonthOffset
        let endOffset = displayRange.endMonthOffset
        return startOffset...endOffset
    }
    
    /// 현재 표시 중인 날짜 (스크롤 위치 기반)
    var currentDisplayDate: Date {
        return calendar.date(byAdding: .month, value: scrollPosition, to: Date()) ?? Date()
    }
    
    // MARK: - Calendar Day Model
    struct CalendarDay: Identifiable {
        let id = UUID()                    // SwiftUI ForEach용 고유 ID
        let date: Date                     // 실제 날짜
        let day: Int                       // 날짜 숫자 (1~31)
        let isCurrentMonth: Bool           // 현재 월에 속하는지
        let isToday: Bool                  // 오늘인지
        let isSelected: Bool               // 선택되었는지
        let isHighlighted: Bool            // 하이라이트되었는지
        let isDisabled: Bool               // 비활성화되었는지
        let isInRange: Bool                // 범위 선택의 중간에 있는지
        let hasImage: Bool                 // 이미지가 있는지
        let imageName: String?             // 이미지 파일명
        let isStartDate: Bool              // 범위 선택의 시작일인지
        let isEndDate: Bool                // 범위 선택의 종료일인지
    }
    
    // MARK: - Initializer
    init(configuration: CustomCalendarConfiguration = CustomCalendarConfiguration()) {
        self.configuration = configuration
        
        // 현재 날짜가 기준
        let targetDate = Date()
        if configuration.effectiveDisplayRange.contains(targetDate) {
            scrollPosition = 0 
        } else {
            // 현재 날짜가 범위 밖이면 범위 시작으로 설정
            scrollPosition = configuration.effectiveDisplayRange.startMonthOffset
        }
    }
    
    // MARK: - Public Methods
    
    /// 날짜 선택 처리 - 선택 모드에 따라 다르게 동작
    func selectDate(_ date: Date) {
        switch configuration.selectionMode {
        case .single:
            selectedDate = date
        case .range:
            handleRangeSelection(date)
        case .multiple:
            handleMultipleSelection(date)
        case .navigate:
            configuration.onNavigate?(date)
        case .readonly:
            break // 아무것도 하지 않음
        }
    }
    
    /// 특정 월의 날짜 데이터 생성 (monthOffset 기반)
    func generateDaysForMonth(offset: Int) -> [CalendarDay] {
        guard let targetDate = calendar.date(byAdding: .month, value: offset, to: Date()) else {
            return []
        }
        
        return generateCalendarDays(for: targetDate)
    }
    
    /// 월/년 문자열 반환 (monthOffset 기반)
    func monthYearString(for offset: Int) -> String {
        guard let targetDate = calendar.date(byAdding: .month, value: offset, to: Date()) else {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월"
        return formatter.string(from: targetDate)
    }
    
    /// 특정 날짜로 스크롤 이동
    func scrollToDate(_ date: Date) {
        let components = calendar.dateComponents([.month], from: Date(), to: date)
        if let monthOffset = components.month {
            scrollPosition = monthOffset
        }
    }
    
    /// 오늘로 스크롤 이동
    func scrollToToday() {
        scrollPosition = 0
    }
    
    /// 선택 상태 초기화
    func clearSelection() {
        selectedDate = nil
        selectedRange = CustomCalendarConfiguration.DateRange(startDate: nil, endDate: nil)
        selectedDates.removeAll()
    }
    
    /// Configuration 업데이트
    func updateConfiguration(_ newConfiguration: CustomCalendarConfiguration) {
        self.configuration = newConfiguration
    }
    
    // MARK: - Private Methods
    
    /// 범위 선택 처리 로직
    private func handleRangeSelection(_ date: Date) {
        if selectedRange?.startDate == nil {
            // 상태 1: 시작일 설정
            selectedRange = CustomCalendarConfiguration.DateRange(startDate: date, endDate: nil)
        } else if selectedRange?.endDate == nil {
            // 상태 2: 종료일 설정
            guard let startDate = selectedRange?.startDate else { return }
            
            if date >= startDate {
                // 정상적인 범위 (시작일 <= 종료일)
                selectedRange = CustomCalendarConfiguration.DateRange(startDate: startDate, endDate: date)
            } else {
                // 역순 선택 시 새로운 시작일로 재설정
                selectedRange = CustomCalendarConfiguration.DateRange(startDate: date, endDate: nil)
            }
        } else {
            // 상태 3: 이미 완성된 범위에서 새로운 시작일 설정
            selectedRange = CustomCalendarConfiguration.DateRange(startDate: date, endDate: nil)
        }
    }
    
    /// 다중 선택 처리 로직
    private func handleMultipleSelection(_ date: Date) {
        if selectedDates.contains(date) {
            selectedDates.remove(date)    // 이미 선택된 날짜는 해제
        } else {
            selectedDates.insert(date)    // 새로운 날짜는 추가
        }
    }
    
    /// 특정 월의 캘린더 그리드 구성
    private func generateCalendarDays(for targetDate: Date) -> [CalendarDay] {
        var days: [CalendarDay] = []
        
        // 1. 현재 월의 시작일과 끝일 계산
        let monthInterval = calendar.dateInterval(of: .month, for: targetDate)!
        let firstDay = monthInterval.start
        
        // 2. 첫 주의 시작일 계산 (일요일부터 시작하도록)
        let firstWeekday = calendar.component(.weekday, from: firstDay)
        let startOfWeek = calendar.date(byAdding: .day, value: -(firstWeekday - 1), to: firstDay)!
        
        // 3. 해당 월에 필요한 주 수 계산
        let lastDay = calendar.date(byAdding: .day, value: -1, to: monthInterval.end)!
        let lastWeekday = calendar.component(.weekday, from: lastDay)
        let weeksNeeded = (calendar.component(.day, from: lastDay) + firstWeekday - 2) / 7 + 1
        let totalDays = weeksNeeded * 7
        
        // 4. 날짜 생성
        for i in 0..<totalDays {
            guard let date = calendar.date(byAdding: .day, value: i, to: startOfWeek) else { continue }
            
            let day = calendar.component(.day, from: date)
            let isCurrentMonth = calendar.isDate(date, equalTo: targetDate, toGranularity: .month)
            let isToday = calendar.isDateInToday(date)
            let normalizedDate = calendar.startOfDay(for: date)
            
            // 5. 각 날짜의 상태 계산
            let calendarDay = CalendarDay(
                date: date,
                day: day,
                isCurrentMonth: isCurrentMonth,
                isToday: isToday,
                isSelected: isDateSelected(date),
                isHighlighted: configuration.highlightedDates.contains(normalizedDate),
                isDisabled: isDateDisabled(date),
                isInRange: isDateInSelectedRange(date),
                hasImage: configuration.dateImages[normalizedDate] != nil,
                imageName: configuration.dateImages[normalizedDate],
                isStartDate: isDateRangeStartDate(date),
                isEndDate: isDateRangeEndDate(date)
            )
            
            days.append(calendarDay)
        }
        
        return days
    }
    
    /// 날짜 선택 상태 확인
    private func isDateSelected(_ date: Date) -> Bool {
        let normalizedDate = calendar.startOfDay(for: date)
        
        switch configuration.selectionMode {
        case .single:
            guard let selected = selectedDate else { return false }
            return calendar.isDate(normalizedDate, inSameDayAs: selected)
        case .range:
            return isDateRangeEndpoint(date)
        case .multiple:
            return selectedDates.contains(normalizedDate)
        case .navigate, .readonly:
            return false
        }
    }
    
    /// 범위 선택의 시작/끝점인지 확인
    private func isDateRangeEndpoint(_ date: Date) -> Bool {
        return isDateRangeStartDate(date) || isDateRangeEndDate(date)
    }
    
    /// 범위 선택의 시작일인지 확인
    private func isDateRangeStartDate(_ date: Date) -> Bool {
        guard let startDate = selectedRange?.startDate else { return false }
        return calendar.isDate(date, inSameDayAs: startDate)
    }
    
    /// 범위 선택의 종료일인지 확인
    private func isDateRangeEndDate(_ date: Date) -> Bool {
        guard let endDate = selectedRange?.endDate else { return false }
        return calendar.isDate(date, inSameDayAs: endDate)
    }
    
    /// 선택된 범위 내 날짜인지 확인
    private func isDateInSelectedRange(_ date: Date) -> Bool {
        guard configuration.selectionMode == .range,
              let startDate = selectedRange?.startDate,
              let endDate = selectedRange?.endDate else {
            return false
        }
        
        let normalizedDate = calendar.startOfDay(for: date)
        let normalizedStart = calendar.startOfDay(for: startDate)
        let normalizedEnd = calendar.startOfDay(for: endDate)
        
        return normalizedDate > normalizedStart && normalizedDate < normalizedEnd
    }
    
    /// 비활성화된 날짜인지 확인
    private func isDateDisabled(_ date: Date) -> Bool {
        let normalizedDate = calendar.startOfDay(for: date)
        
        // 1. 표시 범위 밖인 경우
        if !configuration.effectiveDisplayRange.contains(date) {
            return true
        }
        
        // 2. 설정된 비활성화 날짜
        if configuration.disabledDates.contains(normalizedDate) {
            return true
        }
        
        // 3. 최소/최대 날짜 범위 확인
        if let minDate = configuration.minDate, normalizedDate < calendar.startOfDay(for: minDate) {
            return true
        }
        
        if let maxDate = configuration.maxDate, normalizedDate > calendar.startOfDay(for: maxDate) {
            return true
        }
        
        return false
    }
}
