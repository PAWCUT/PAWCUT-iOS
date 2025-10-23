//
//  FrameType.swift
//  PawCut
//
//  Created by Jay on 9/24/25.
//

import Foundation

enum FrameType: String, CaseIterable {
    case halloween, snow, ink, cobalt, peek, heart, cloud, blush, wave, sparkle, dawn,
        bloom, breeze, blue, ginkgo
    
    var frameScrollImageName: String { "\(rawValue)_scroll" }
    
    var frameImageName: String { "\(rawValue)_frame" }
    
    var displayName: String { rawValue.prefix(1).uppercased() + rawValue.dropFirst() }
    
    // 할로윈 이벤트 종료 날짜 (2025년 10월 31일 23:59:59)
    private static let halloweenEndDate: Date = {
        var components = DateComponents()
        components.year = 2025
        components.month = 10
        components.day = 31
        components.hour = 23
        components.minute = 59
        components.second = 59
        return Calendar.current.date(from: components) ?? Date()
    }()
    
    // 할로윈 이전 여부 캐싱
    private static let isHalloweenEventActive: Bool = {
        Date() <= halloweenEndDate
    }()
    
    static let sortedCases: [FrameType] = {
        var frames = FrameType.allCases
        
        if isHalloweenEventActive {
            // 할로윈을 맨 앞으로
            frames.removeAll { $0 == .halloween }
            frames.insert(.halloween, at: 0)
        } else {
            // 할로윈을 맨 뒤로
            frames.removeAll { $0 == .halloween }
            frames.append(.halloween)
        }
        
        return frames
    }()
}
