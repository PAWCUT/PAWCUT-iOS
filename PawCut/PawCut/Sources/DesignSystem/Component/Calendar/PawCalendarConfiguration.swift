//
//  PawCalendarConfiguration.swift
//  PawCut
//
//  Created by taeni on 8/11/25.
//

import SwiftUI
import Foundation

struct PawCalendarConfiguration {
    
    enum SelectionMode {
        case single        // 단일 날짜만 선택 가능
        case range         // 범위 선택 (시작일~종료일)
        case multiple      // 여러 날짜 동시 선택
        case readonly      // 읽기 전용 (선택 불가, 표시만)
        case navigate      // 날짜 선택 시 Navigate 모드 (날짜 선택 시 콜백 호출)
    }
    
    struct DateRange {
        let startDate: Date?
        let endDate: Date?
        
        var isComplete: Bool {
            startDate != nil && endDate != nil
        }
        
        static let empty = DateRange(startDate: nil, endDate: nil)
    }
    
    struct DisplayRange {
        let startDate: Date
        let endDate: Date
        
        static func aroundToday(years: Int = 2) -> DisplayRange {
            let calendar = Calendar.current
            let now = Date()
            let start = calendar.date(byAdding: .year, value: -years, to: now) ?? now
            let end = calendar.date(byAdding: .year, value: years, to: now) ?? now
            return DisplayRange(startDate: start, endDate: end)
        }
        
        static func months(from startYear: Int, startMonth: Int, to endYear: Int, endMonth: Int) -> DisplayRange {
            let calendar = Calendar.current
            let startComponents = DateComponents(year: startYear, month: startMonth, day: 1)
            let endComponents = DateComponents(year: endYear, month: endMonth, day: 1)
            
            let startDate = calendar.date(from: startComponents) ?? Date()
            let tempEndDate = calendar.date(from: endComponents) ?? Date()
            let endDate = calendar.dateInterval(of: .month, for: tempEndDate)?.end ?? tempEndDate
            
            return DisplayRange(startDate: startDate, endDate: endDate)
        }
        
        func contains(_ date: Date) -> Bool {
            return date >= startDate && date <= endDate
        }
        
        var monthOffsetRange: ClosedRange<Int> {
            let calendar = Calendar.current
            let now = Date()
            let startComponents = calendar.dateComponents([.month], from: now, to: startDate)
            let endComponents = calendar.dateComponents([.month], from: now, to: endDate)
            
            let startOffset = startComponents.month ?? 0
            let endOffset = endComponents.month ?? 0
            
            return startOffset...endOffset
        }
    }
    
    struct Appearance {
        let primaryColor: Color
        let backgroundColor: Color
        let weekColor: Color
        let dayColor: Color
        let selectedTextColor: Color
        let disabledTextColor: Color
        let todayColor: Color
        let rangeBackgroundColor: Color
        let dayTextFont: Font
        let headerFont: Font
        let weekdayFont: Font
        let cellSize: CGFloat
        let cornerRadius: CGFloat
        
        static let pawCutTheme = Appearance(
            primaryColor: .grayScale01,
            backgroundColor: .white,
            weekColor: .grayScale03,
            dayColor: .grayScale01,
            selectedTextColor: .grayScale05,
            disabledTextColor: .grayScale04,
            todayColor: .clear,
            rangeBackgroundColor: .grayScale05,
            dayTextFont: PawButtonStyle.semi14.font,
            headerFont: PawButtonStyle.semi16.font,
            weekdayFont: PawButtonStyle.med12.font,
            cellSize: 40,
            cornerRadius: 20
        )
    }
    
    let selectionMode: SelectionMode
    let appearance: Appearance
    let displayRange: DisplayRange?
    let minDate: Date?
    let maxDate: Date?
    let highlightedDates: Set<Date>
    let disabledDates: Set<Date>
    let dateImages: [Date: String]
    let onNavigate: ((Date) -> Void)?
    
    var effectiveDisplayRange: DisplayRange {
        return displayRange ?? .aroundToday()
    }
    
    init(
        selectionMode: SelectionMode = .single,
        appearance: Appearance = .pawCutTheme,
        displayRange: DisplayRange? = nil,
        minDate: Date? = nil,
        maxDate: Date? = nil,
        highlightedDates: Set<Date> = [],
        disabledDates: Set<Date> = [],
        dateImages: [Date: String] = [:],
        onNavigate: ((Date) -> Void)? = nil
    ) {
        self.selectionMode = selectionMode
        self.appearance = appearance
        self.displayRange = displayRange
        self.minDate = minDate
        self.maxDate = maxDate
        self.highlightedDates = highlightedDates
        self.disabledDates = disabledDates
        self.dateImages = dateImages
        self.onNavigate = onNavigate
    }
}

// MARK: - 편의 생성자들
extension PawCalendarConfiguration {
    
    static func singleSelection(
        from startYear: Int, startMonth: Int,
        to endYear: Int, endMonth: Int
    ) -> PawCalendarConfiguration {
        return PawCalendarConfiguration(
            selectionMode: .single,
            displayRange: .months(from: startYear, startMonth: startMonth,
                                  to: endYear, endMonth: endMonth)
        )
    }
    
    static func rangeSelection(
        from startYear: Int, startMonth: Int,
        to endYear: Int, endMonth: Int
    ) -> PawCalendarConfiguration {
        return PawCalendarConfiguration(
            selectionMode: .range,
            displayRange: .months(from: startYear, startMonth: startMonth,
                                  to: endYear, endMonth: endMonth)
        )
    }
    
    static func navigationMode(
        from startYear: Int, startMonth: Int,
        to endYear: Int, endMonth: Int,
        dateImages: [Date: String] = [:],
        onNavigate: @escaping (Date) -> Void
    ) -> PawCalendarConfiguration {
        return PawCalendarConfiguration(
            selectionMode: .navigate,
            displayRange: .months(from: startYear, startMonth: startMonth,
                                  to: endYear, endMonth: endMonth),
            dateImages: dateImages,
            onNavigate: onNavigate
        )
    }
}
