//
//  PawCalendarView.swift
//  PawCut
//
//  Created by taeni on 8/11/25.
//

import SwiftUI

struct PawCalendarView: View {
    
    // MARK: - Properties
    let configuration: PawCalendarConfiguration
    let onDateSelected: ((Date) -> Void)?
    
    @State var selectedDate: Date?
    @State var selectedRange: PawCalendarConfiguration.DateRange = .empty
    @State var selectedDates: Set<Date> = []
    @State var scrollPosition: Int = 0
    
    let calendar = Calendar.current
    let weekdaySymbols = ["일", "월", "화", "수", "목", "금", "토"]
    
    // MARK: - Initializer
    init(
        configuration: PawCalendarConfiguration = PawCalendarConfiguration(),
        onDateSelected: ((Date) -> Void)? = nil
    ) {
        self.configuration = configuration
        self.onDateSelected = onDateSelected
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        ForEach(Array(monthOffsetRange), id: \.self) { monthOffset in
                            monthView(for: monthOffset)
                                .id(monthOffset)
                        }
                    }
                }
                .onAppear {
                    DispatchQueue.main.async {
                        proxy.scrollTo(scrollPosition, anchor: .top)
                    }
                }
                .onChange(of: scrollPosition) { _, newPosition in
                    withAnimation(.easeInOut(duration: 0.3)) {
                        proxy.scrollTo(newPosition, anchor: .top)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .background(configuration.appearance.backgroundColor)
    }
    
    // MARK: - Subviews
    private var weekdayHeaderView: some View {
        HStack(spacing: 0) {
            ForEach(weekdaySymbols, id: \.self) { weekday in
                Text(weekday)
                    .font(configuration.appearance.weekdayFont)
                    .multilineTextAlignment(.center)
                    .foregroundColor(configuration.appearance.weekColor)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 10)
    }
    
    private func monthView(for monthOffset: Int) -> some View {
        let days = generateDaysForMonth(offset: monthOffset)
        
        return VStack(spacing: 0) {
            monthHeaderView(for: monthOffset)
            
            weekdayHeaderView
                .background(configuration.appearance.backgroundColor)
            
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible()), count: 7)
            ) {
                ForEach(days) { day in
                    PawCalendarDayView(
                        day: day,
                        configuration: configuration,
                        onTap: {
                            let normalizedDate = calendar.startOfDay(for: day.date)
                            handleDateSelection(day.date)
                            onDateSelected?(normalizedDate)
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
            Text(monthYearString(for: monthOffset))
                .font(configuration.appearance.headerFont)
                .foregroundColor(configuration.appearance.dayColor)
            
            Spacer()
        }
        .padding(.vertical, 20)
    }
}

// MARK: - Day View
struct PawCalendarDayView: View {
    let day: PawCalendarDay
    let configuration: PawCalendarConfiguration
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
                    if day.hasImage {
                        imageBackgroundView
                    } else {
                        defaultBackgroundView
                    }
                    
                    Text("\(day.day)")
                        .font(configuration.appearance.dayTextFont)
                        .foregroundColor(textColor)
                        .shadow(color: day.hasImage ? .black.opacity(0.7) : .clear,
                                radius: day.hasImage ? 1 : 0,
                                x: 0, y: 1)
                }
            }
            .frame(minHeight: 45)
            .buttonStyle(PlainButtonStyle())
            .disabled(day.isDisabled)
            .opacity(day.isDisabled ? 0.3 : 1.0)
        }
    }
    
    private var imageBackgroundView: some View {
        //        AsyncPhotoImageView(fileName: day.imageName ?? "")
        ImageComponent(imageName: "mock_sample", size: CGSize(width: configuration.appearance.cellSize*2, height: configuration.appearance.cellSize*2))
            .frame(width: configuration.appearance.cellSize, height: configuration.appearance.cellSize)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(
                        day.isToday ? configuration.appearance.todayColor : .clear,
                        lineWidth: day.isToday ? 2 : 0
                    )
            )
    }
    
    private var defaultBackgroundView: some View {
        ZStack {
            // 범위 선택 배경
            if day.isInRange {
                Rectangle()
                    .fill(configuration.appearance.rangeBackgroundColor)
                    .frame(maxHeight: configuration.appearance.cellSize)
            }
            
            // 범위 선택 반원 처리
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
        }
    }
    
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
    
    private var textColor: Color {
        if day.isDisabled {
            return configuration.appearance.disabledTextColor
        } else if day.isSelected {
            return configuration.appearance.selectedTextColor
        } else if day.isInRange {
            return configuration.appearance.dayColor
        } else if day.hasImage {
            return configuration.appearance.selectedTextColor
        } else {
            return configuration.appearance.dayColor
        }
    }
}
