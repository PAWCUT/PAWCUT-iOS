//
//  PawCalendarDay.swift
//  PawCut
//
//  Created by taeni on 8/11/25.
//

import Foundation

struct PawCalendarDay: Identifiable {
    let id = UUID()
    let date: Date
    let day: Int
    let isCurrentMonth: Bool
    let isToday: Bool
    let isSelected: Bool
    let isHighlighted: Bool
    let isDisabled: Bool
    let isInRange: Bool
    let hasImage: Bool
    let imageName: String?
    let isStartDate: Bool
    let isEndDate: Bool
}
