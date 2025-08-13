//
//  PawCalendarView+.swift
//  PawCut
//
//  Created by taeni on 8/11/25.
//

import SwiftUI
import Foundation

// MARK: - Computed Properties
extension PawCalendarView {
    
    var monthOffsetRange: ClosedRange<Int> {
        return configuration.effectiveDisplayRange.monthOffsetRange
    }
    
    var currentDisplayDate: Date {
        return calendar.date(byAdding: .month, value: scrollPosition, to: Date()) ?? Date()
    }
}

// MARK: - Date Selection Logic
extension PawCalendarView {
    
    func handleDateSelection(_ date: Date) {
        // 날짜 선택 시 정규화된 날짜 사용 (시간 부분 제거)
        let normalizedDate = calendar.startOfDay(for: date)
        
        switch configuration.selectionMode {
        case .single:
            selectedDate = normalizedDate
        case .range:
            handleRangeSelection(normalizedDate)
        case .multiple:
            handleMultipleSelection(normalizedDate)
        case .navigate:
            configuration.onNavigate?(normalizedDate)
        case .readonly:
            break
        }
    }
    
    private func handleRangeSelection(_ date: Date) {
        let normalizedDate = calendar.startOfDay(for: date)
        
        if selectedRange.startDate == nil {
            selectedRange = PawCalendarConfiguration.DateRange(startDate: normalizedDate, endDate: nil)
        } else if selectedRange.endDate == nil {
            guard let startDate = selectedRange.startDate else { return }
            
            if normalizedDate >= startDate {
                selectedRange = PawCalendarConfiguration.DateRange(startDate: startDate, endDate: normalizedDate)
            } else {
                selectedRange = PawCalendarConfiguration.DateRange(startDate: normalizedDate, endDate: nil)
            }
        } else {
            selectedRange = PawCalendarConfiguration.DateRange(startDate: normalizedDate, endDate: nil)
        }
    }
    
    private func handleMultipleSelection(_ date: Date) {
        let normalizedDate = calendar.startOfDay(for: date)
        
        if selectedDates.contains(normalizedDate) {
            selectedDates.remove(normalizedDate)
        } else {
            selectedDates.insert(normalizedDate)
        }
    }
}

// MARK: - Calendar Generation
extension PawCalendarView {
    
    func generateDaysForMonth(offset: Int) -> [PawCalendarDay] {
        guard let targetDate = calendar.date(byAdding: .month, value: offset, to: Date()) else {
            return []
        }
        
        return generateCalendarDays(for: targetDate)
    }
    
    private func generateCalendarDays(for targetDate: Date) -> [PawCalendarDay] {
        var days: [PawCalendarDay] = []
        
        // 현재 월의 시작일과 끝일 계산
        let monthInterval = calendar.dateInterval(of: .month, for: targetDate)!
        let firstDay = monthInterval.start
        
        // 첫 주의 시작일 계산 (일요일부터 시작)
        let firstWeekday = calendar.component(.weekday, from: firstDay)
        let startOfWeek = calendar.date(byAdding: .day, value: -(firstWeekday - 1), to: firstDay)!
        
        // 해당 월에 필요한 주 수 계산
        let lastDay = calendar.date(byAdding: .day, value: -1, to: monthInterval.end)!
        let weeksNeeded = (calendar.component(.day, from: lastDay) + firstWeekday - 2) / 7 + 1
        let totalDays = weeksNeeded * 7
        
        // 날짜 생성
        for i in 0..<totalDays {
            guard let date = calendar.date(byAdding: .day, value: i, to: startOfWeek) else { continue }
            
            let day = calendar.component(.day, from: date)
            let isCurrentMonth = calendar.isDate(date, equalTo: targetDate, toGranularity: .month)
            let isToday = calendar.isDateInToday(date)
            let normalizedDate = calendar.startOfDay(for: date)
            
            let calendarDay = PawCalendarDay(
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
}

// MARK: - Date State Checking
extension PawCalendarView {
    
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
    
    private func isDateRangeEndpoint(_ date: Date) -> Bool {
        return isDateRangeStartDate(date) || isDateRangeEndDate(date)
    }
    
    private func isDateRangeStartDate(_ date: Date) -> Bool {
        guard let startDate = selectedRange.startDate else { return false }
        return calendar.isDate(date, inSameDayAs: startDate)
    }
    
    private func isDateRangeEndDate(_ date: Date) -> Bool {
        guard let endDate = selectedRange.endDate else { return false }
        return calendar.isDate(date, inSameDayAs: endDate)
    }
    
    private func isDateInSelectedRange(_ date: Date) -> Bool {
        guard configuration.selectionMode == .range,
              let startDate = selectedRange.startDate,
              let endDate = selectedRange.endDate else {
            return false
        }
        
        let normalizedDate = calendar.startOfDay(for: date)
        let normalizedStart = calendar.startOfDay(for: startDate)
        let normalizedEnd = calendar.startOfDay(for: endDate)
        
        return normalizedDate > normalizedStart && normalizedDate < normalizedEnd
    }
    
    private func isDateDisabled(_ date: Date) -> Bool {
        let normalizedDate = calendar.startOfDay(for: date)
        
        // 표시 범위 밖인 경우
        if !configuration.effectiveDisplayRange.contains(date) {
            return true
        }
        
        // 설정된 비활성화 날짜
        if configuration.disabledDates.contains(normalizedDate) {
            return true
        }
        
        // 최소/최대 날짜 범위 확인
        if let minDate = configuration.minDate, normalizedDate < calendar.startOfDay(for: minDate) {
            return true
        }
        
        if let maxDate = configuration.maxDate, normalizedDate > calendar.startOfDay(for: maxDate) {
            return true
        }
        
        return false
    }
}

// MARK: - Utility Methods
extension PawCalendarView {
    
    func monthYearString(for offset: Int) -> String {
        guard let targetDate = calendar.date(byAdding: .month, value: offset, to: Date()) else {
            return ""
        }
        
        return targetDate.koreanYearMonthString
    }
    
    func scrollToDate(_ date: Date) {
        let components = calendar.dateComponents([.month], from: Date(), to: date)
        if let monthOffset = components.month {
            scrollPosition = monthOffset
        }
    }
    
    func scrollToToday() {
        scrollPosition = 0
    }
    
    func clearSelection() {
        selectedDate = nil
        selectedRange = .empty
        selectedDates.removeAll()
    }
}

// MARK: - Static Factory Methods
extension PawCalendarView {
    
    static func defaultCalendar(onDateSelected: ((Date) -> Void)? = nil) -> PawCalendarView {
        return PawCalendarView(onDateSelected: onDateSelected)
    }
    
    static func custom(configuration: PawCalendarConfiguration, onDateSelected: ((Date) -> Void)? = nil) -> PawCalendarView {
        return PawCalendarView(configuration: configuration, onDateSelected: onDateSelected)
    }
    
    static func withDateRange(from startYear: Int, startMonth: Int, to endYear: Int, endMonth: Int,
                              selectionMode: PawCalendarConfiguration.SelectionMode = .single, onDateSelected: ((Date) -> Void)? = nil) -> PawCalendarView {
        let config = PawCalendarConfiguration(
            selectionMode: selectionMode,
            displayRange: .months(from: startYear, startMonth: startMonth,
                                  to: endYear, endMonth: endMonth)
        )
        return PawCalendarView(configuration: config, onDateSelected: onDateSelected)
    }
    
    static func navigation(from startYear: Int, startMonth: Int, to endYear: Int, endMonth: Int,
                           dateImages: [Date: String] = [:], onNavigate: @escaping (Date) -> Void) -> PawCalendarView {
        let config = PawCalendarConfiguration.navigationMode(
            from: startYear, startMonth: startMonth,
            to: endYear, endMonth: endMonth,
            dateImages: dateImages,
            onNavigate: onNavigate
        )
        return PawCalendarView(configuration: config)
    }
}
