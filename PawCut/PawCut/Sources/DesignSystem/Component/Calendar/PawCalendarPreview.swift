//
//  PawCalendarPreview.swift
//  PawCut
//
//  Created by taeni on 8/11/25.
//

import SwiftUI

// MARK: - Preview Examples
#Preview("기본 캘린더") {
    PawCalendarView.defaultCalendar { date in
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        print("기본 캘린더 선택: \(formatter.string(from: date))")
    }
    .frame(maxHeight: .infinity)
    .padding(.vertical)
}

#Preview("범위 선택 캘린더") {
    RangeSelectionPreview()
        .frame(maxHeight: .infinity)
        .padding(.vertical)
}

#Preview("다중 선택 캘린더") {
    MultipleSelectionPreview()
        .frame(maxHeight: .infinity)
        .padding(.vertical)
}

#Preview("네비게이션 모드 (사진 있는 날짜)") {
    NavigationPreview()
        .frame(maxHeight: .infinity)
        .padding(.vertical)
}

#Preview("커스텀 테마") {
    let customAppearance = PawCalendarConfiguration.Appearance(
        primaryColor: .pointPurple01,
        backgroundColor: .white,
        weekColor: .grayScale03,
        dayColor: .grayScale01,
        selectedTextColor: .white,
        disabledTextColor: .grayScale04,
        todayColor: .pointPurple01,
        rangeBackgroundColor: .pointPurple02,
        dayTextFont: FontSet.pretendard(size: ._14, weight: .semibold),
        headerFont: FontSet.pretendard(size: ._18, weight: .bold),
        weekdayFont: FontSet.pretendard(size: ._12, weight: .medium),
        cellSize: 45,
        cornerRadius: 22
    )
    
    let customConfig = PawCalendarConfiguration(
        selectionMode: .multiple,
        appearance: customAppearance,
        displayRange: .months(from: 2024, startMonth: 6, to: 2025, endMonth: 12)
    )
    
    PawCalendarView.custom(configuration: customConfig) { date in
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        print("커스텀 캘린더 선택: \(formatter.string(from: date))")
    }
}

// MARK: - 범위 선택 Preview
struct RangeSelectionPreview: View {
    @State private var selectedRange: PawCalendarConfiguration.DateRange = .empty
    
    var body: some View {
        PawCalendarView.withDateRange(
            from: 2024, startMonth: 1,
            to: 2026, endMonth: 12,
            selectionMode: .range
        ) { date in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            if selectedRange.startDate == nil {
                // 시작일 선택
                selectedRange = PawCalendarConfiguration.DateRange(startDate: date, endDate: nil)
                print("시작일 선택: \(formatter.string(from: date))")
            } else if selectedRange.endDate == nil {
                // 종료일 선택
                if let startDate = selectedRange.startDate {
                    if date >= startDate {
                        selectedRange = PawCalendarConfiguration.DateRange(startDate: startDate, endDate: date)
                        print("범위 완성: \(formatter.string(from: startDate)) ~ \(formatter.string(from: date))")
                    } else {
                        // 시작일보다 이전 날짜 선택 시 시작일 재설정
                        selectedRange = PawCalendarConfiguration.DateRange(startDate: date, endDate: nil)
                        print("시작일 재선택: \(formatter.string(from: date))")
                    }
                }
            } else {
                // 이미 범위가 완성된 상태에서 새로운 시작일 선택
                selectedRange = PawCalendarConfiguration.DateRange(startDate: date, endDate: nil)
                print("새로운 시작일 선택: \(formatter.string(from: date))")
            }
        }
    }
}

// MARK: - 네비게이션 Preview
struct NavigationPreview: View {
    @State private var navigationPath = NavigationPath()
    
    // 예시 mock data
    private let mockDateImages = CalendarMockData.randomDateImages(pastDays: 30, probability: 0.5)
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            PawCalendarView.navigation(
                from: 2025, startMonth: 1,
                to: 2025, endMonth: 8,
                dateImages: mockDateImages
            ) { date in
                // 사진이 있는 날짜만 처리
                if let imageName = mockDateImages[date] {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    print("네비게이션 선택 (사진 있음): \(formatter.string(from: date)) - \(imageName)")
                    
                    navigationPath.append(PhotoPreviewDestination(date: date, imageName: imageName))
                }
            }
            .navigationDestination(for: PhotoPreviewDestination.self) { destination in
                PhotoDetailPreview(
                    selectedDate: destination.date,
                    imageName: destination.imageName
                )
            }
        }
    }
}

// MARK: - Photo Destination
struct PhotoPreviewDestination: Hashable {
    let date: Date
    let imageName: String
}

// MARK: - 사진 상세 뷰 (예제)
struct PhotoDetailPreview: View {
    let selectedDate: Date
    let imageName: String
    
    var body: some View {
        VStack(spacing: 20) {
            // 날짜 표시
            Text(selectedDate.koreanYearMonthDateString)
                .font(.title2)
                .fontWeight(.bold)
            Spacer()
        }
    }
}
struct MultipleSelectionPreview: View {
    @State private var selectedDates: Set<Date> = []
    
    var body: some View {
        PawCalendarView.withDateRange(
            from: 2024, startMonth: 1,
            to: 2026, endMonth: 12,
            selectionMode: .multiple
        ) { date in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            if selectedDates.contains(date) {
                selectedDates.remove(date)
                print("날짜 제거: \(formatter.string(from: date))")
            } else {
                selectedDates.insert(date)
                print("날짜 추가: \(formatter.string(from: date))")
            }
            
            // 선택된 모든 날짜를 정렬해서 출력
            let sortedDates = selectedDates.sorted()
            let dateStrings = sortedDates.map { formatter.string(from: $0) }
            print("선택된 모든 날짜: \(dateStrings)")
        }
    }
}

// MARK: - 사용 예제 뷰
struct CalendarExampleView: View {
    @State private var selectedMode: SelectionMode = .single
    
    enum SelectionMode: String, CaseIterable {
        case single = "단일 선택"
        case range = "범위 선택"
        case multiple = "다중 선택"
        case navigate = "네비게이션"
    }
    
    var body: some View {
        VStack {
            // 모드 선택
            Picker("Selection Mode", selection: $selectedMode) {
                ForEach(SelectionMode.allCases, id: \.self) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            // 캘린더
            Group {
                switch selectedMode {
                case .single:
                    singleSelectionCalendar
                case .range:
                    RangeSelectionPreview()
                case .multiple:
                    MultipleSelectionPreview()
                case .navigate:
                    NavigationPreview()
                }
            }
            .frame(maxHeight: .infinity)
            
            Spacer()
        }
        .navigationTitle("PawCalendar 예제")
    }
    
    private var singleSelectionCalendar: some View {
        PawCalendarView.withDateRange(
            from: 2024, startMonth: 1,
            to: 2026, endMonth: 12,
            selectionMode: .single
        ) { date in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            print("단일 선택: \(formatter.string(from: date))")
        }
    }
}

// MARK: - 사용 예제의 네비게이션 캘린더
struct NavigationCalendarExample: View {
    @State private var navigationPath = NavigationPath()
    
    private let mockImages = CalendarMockData.intervalDateImages(pastDays: 20, interval: 3, filePrefix: "photo_")
    
    var body: some View {
        PawCalendarView.navigation(
            from: 2024, startMonth: 1,
            to: 2026, endMonth: 12,
            dateImages: mockImages
        ) { date in
            // 사진이 있는 날짜만 처리
            if let imageName = mockImages[date] {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                print("네비게이션 선택 (사진 있음): \(formatter.string(from: date)) - \(imageName)")
                
                navigationPath.append(PhotoPreviewDestination(date: date, imageName: imageName))
            }
        }
        .navigationDestination(for: PhotoPreviewDestination.self) { destination in
            PhotoDetailPreview(
                selectedDate: destination.date,
                imageName: destination.imageName
            )
        }
    }
}

#Preview("사용 예제") {
    NavigationStack {
        CalendarExampleView()
    }
}
