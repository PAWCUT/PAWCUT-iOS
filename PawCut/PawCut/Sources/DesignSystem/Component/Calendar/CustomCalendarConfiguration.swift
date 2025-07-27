//
//  CustomCalendarConfiguration.swift
//  PawCut
//
//  Created by taeni on 7/26/25.
//

import SwiftUI
import Foundation

struct CustomCalendarConfiguration {
    
    enum SelectionMode {
        case single        // 단일 날짜만 선택 가능
        case range         // 범위 선택 (시작일~종료일)
        case multiple      // 여러 날짜 동시 선택
        case readonly      // 읽기 전용 (선택 불가, 표시만)
        case navigate      // 네비게이션 모드 (날짜 선택 시 콜백 호출)
    }
    
    struct DateRange {
        let startDate: Date?    // 시작일 (nil 가능)
        let endDate: Date?      // 종료일 (nil 가능)
        
        // 범위가 선택 되었는가?
        var isComplete: Bool {
            startDate != nil && endDate != nil
        }
    }
    
    struct DisplayRange {
        let startDate: Date     // 표시할 가장 이른 날짜
        let endDate: Date       // 표시할 가장 늦은 날짜
        
        /// 오늘 기준 전후 N년 (동적 기본값)
        static func aroundToday(years: Int = 2) -> DisplayRange {
            let calendar = Calendar.current
            let now = Date()
            let start = calendar.date(byAdding: .year, value: -years, to: now) ?? now
            let end = calendar.date(byAdding: .year, value: years, to: now) ?? now
            return DisplayRange(startDate: start, endDate: end)
        }
        
        /// 연도 범위로 생성 (예: 2020년~2025년)
        static func years(from startYear: Int, to endYear: Int) -> DisplayRange {
            let calendar = Calendar.current
            let startComponents = DateComponents(year: startYear, month: 1, day: 1)
            let endComponents = DateComponents(year: endYear, month: 12, day: 31)
            
            let startDate = calendar.date(from: startComponents) ?? Date()
            let endDate = calendar.date(from: endComponents) ?? Date()
            
            return DisplayRange(startDate: startDate, endDate: endDate)
        }
        
        /// 특정 월 범위로 생성 (정확한 월 단위)
        static func months(from startYear: Int, startMonth: Int, to endYear: Int, endMonth: Int) -> DisplayRange {
            let calendar = Calendar.current
            let startComponents = DateComponents(year: startYear, month: startMonth, day: 1)
            let endComponents = DateComponents(year: endYear, month: endMonth, day: 1)
            
            let startDate = calendar.date(from: startComponents) ?? Date()
            let tempEndDate = calendar.date(from: endComponents) ?? Date()
            let endDate = calendar.dateInterval(of: .month, for: tempEndDate)?.end ?? tempEndDate
            
            return DisplayRange(startDate: startDate, endDate: endDate)
        }
        
        /// 특정 날짜부터 N개월 범위로 생성
        static func fromDate(_ startDate: Date, months: Int) -> DisplayRange {
            let calendar = Calendar.current
            let endDate = calendar.date(byAdding: .month, value: months, to: startDate) ?? startDate
            return DisplayRange(startDate: startDate, endDate: endDate)
        }
        
        /// 특정 날짜가 이 범위에 포함되는지 확인
        func contains(_ date: Date) -> Bool {
            return date >= startDate && date <= endDate
        }
        
        /// 전체 개월 수 계산 (스크롤 뷰 최적화에 활용)
        var totalMonths: Int {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.month], from: startDate, to: endDate)
            return max(1, components.month ?? 1) + 1
        }
        
        /// 시작 월의 오프셋 계산 (현재 날짜 기준)
        var startMonthOffset: Int {
            let calendar = Calendar.current
            let now = Date()
            let components = calendar.dateComponents([.month], from: now, to: startDate)
            return components.month ?? 0
        }
        
        /// 끝 월의 오프셋 계산 (현재 날짜 기준)
        var endMonthOffset: Int {
            let calendar = Calendar.current
            let now = Date()
            let components = calendar.dateComponents([.month], from: now, to: endDate)
            return components.month ?? 0
        }
    }
    
    struct Appearance {
        // 색상 설정
        let primaryColor: Color          // 선택된 날짜 배경색
        let backgroundColor: Color       // 캘린더 전체 배경색
        let weekColor: Color            // 기본 텍스트 색상
        let dayColor: Color            // 기본 텍스트 색상
        let selectedTextColor: Color     // 선택된 날짜 텍스트 색상
        let disabledTextColor: Color    // 비활성화된 날짜 텍스트 색상
        let todayColor: Color           // 오늘 날짜 색상
        let rangeBackgroundColor: Color // 범위 선택 배경색
        
        // 폰트 설정
        let dayTextFont: Font           // 날짜 숫자 폰트
        let headerFont: Font            // 월/년 헤더 폰트
        let weekdayFont: Font           // 요일 폰트
        
        // 크기 및 레이아웃 설정
        let cellSize: CGFloat           // 각 날짜 셀의 크기
        let cornerRadius: CGFloat       // 선택된 날짜의 모서리 둥글기
        
        /// PawCut 앱 전용 테마 (기존 디자인 시스템 활용)
        static let pawCutTheme = Appearance(
            primaryColor: Color.grayScale01,            // 진한 회색 (선택된 날짜)
            backgroundColor: Color.white,               // 시스템 배경색
            weekColor: Color.grayScale03,               // 요일 표시
            dayColor: Color.grayScale01,                // 날짜 진한 회색 (기본 텍스트)
            selectedTextColor: Color.grayScale05,       // 밝은 회색 (선택된 텍스트)
            disabledTextColor: Color.grayScale04,       // 연한 회색 (비활성화)
            todayColor: Color.clear,                    // 메인 컬러 (오늘)
            rangeBackgroundColor: Color.grayScale01,    // 범위 배경색
            dayTextFont: FontSet.pretendard(size: ._14, weight: .semibold),
            headerFont: FontSet.pretendard(size: ._16, weight: .semibold),
            weekdayFont: FontSet.pretendard(size: ._12, weight: .semibold),
            cellSize: 40,
            cornerRadius: 20
        )
    }
    
    let selectionMode: SelectionMode        // 선택 모드
    let appearance: Appearance              // 외관 설정
    let displayRange: DisplayRange?         // 표시 범위 (nil이면 자동 설정)
    let minDate: Date?                      // 선택 가능한 최소 날짜
    let maxDate: Date?                      // 선택 가능한 최대 날짜
    let highlightedDates: Set<Date>         // 하이라이트할 특별한 날짜들
    let disabledDates: Set<Date>           // 비활성화할 날짜들
    let dateImages: [Date: String]         // 날짜별 이미지 (파일명)
    let onNavigate: ((Date) -> Void)?      // 네비게이션 모드 콜백
    
    /// nil이면 오늘 기준 2년 전후로 자동 설정
    var effectiveDisplayRange: DisplayRange {
        return displayRange ?? .aroundToday()
    }
    
    init(
        selectionMode: SelectionMode = .single,
        appearance: Appearance = .pawCutTheme,           // PawCut 테마가 기본
        displayRange: DisplayRange? = nil,               // nil이면 자동 설정
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
extension CustomCalendarConfiguration {
    
    /// 단일 날짜 선택 모드
    static func singleSelection(
        from startYear: Int, startMonth: Int,
        to endYear: Int, endMonth: Int
    ) -> CustomCalendarConfiguration {
        return CustomCalendarConfiguration(
            selectionMode: .single,
            displayRange: .months(from: startYear, startMonth: startMonth,
                                  to: endYear, endMonth: endMonth)
        )
    }
    
    /// 범위 선택 모드
    static func rangeSelection(
        from startYear: Int, startMonth: Int,
        to endYear: Int, endMonth: Int
    ) -> CustomCalendarConfiguration {
        return CustomCalendarConfiguration(
            selectionMode: .range,
            displayRange: .months(from: startYear, startMonth: startMonth,
                                  to: endYear, endMonth: endMonth)
        )
    }
    
    /// 네비게이션 모드 (사진이 있는 날짜 표시)
    static func navigationMode(
        from startYear: Int, startMonth: Int,
        to endYear: Int, endMonth: Int,
        dateImages: [Date: String] = [:],
        onNavigate: @escaping (Date) -> Void
    ) -> CustomCalendarConfiguration {
        return CustomCalendarConfiguration(
            selectionMode: .navigate,
            displayRange: .months(from: startYear, startMonth: startMonth,
                                  to: endYear, endMonth: endMonth),
            dateImages: dateImages,
            onNavigate: onNavigate
        )
    }
}
