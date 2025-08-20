//
//  CalendarMockData.swift
//  PawCut
//
//  Created by taeni on 8/11/25.
//

import Foundation

// MARK: - Mock Data Extension
extension CalendarMockData {
    
    /// 랜덤한 날짜에 사진이 있는 Mock 데이터 생성
    /// - Parameters:
    ///   - days: 과거 며칠까지 생성할지 (기본값: 30일)
    ///   - probability: 사진이 있을 확률 (0.0~1.0, 기본값: 0.5)
    ///   - prefix: 파일명 접두사 (기본값: "mock_photo_")
    /// - Returns: [Date: String] 형태의 이미지 맵
    static func randomDateImages(
        pastDays days: Int = 30,
        probability: Double = 0.5,
        filePrefix prefix: String = "mock_photo_"
    ) -> [Date: String] {
        let calendar = Calendar.current
        var images: [Date: String] = [:]
        
        for i in 0..<days {
            if Double.random(in: 0...1) < probability {
                let date = calendar.date(byAdding: .day, value: -i, to: Date())!
                let normalizedDate = calendar.startOfDay(for: date)
                images[normalizedDate] = "\(prefix)\(i).jpg"
            }
        }
        
        return images
    }
    
    /// 규칙적인 간격으로 사진이 있는 Mock 데이터 생성
    /// - Parameters:
    ///   - days: 과거 며칠까지 생성할지
    ///   - interval: 몇 일 간격으로 사진을 배치할지 (기본값: 3일)
    ///   - prefix: 파일명 접두사 (기본값: "photo_")
    /// - Returns: [Date: String] 형태의 이미지 맵
    static func intervalDateImages(
        pastDays days: Int = 30,
        interval: Int = 3,
        filePrefix prefix: String = "photo_"
    ) -> [Date: String] {
        let calendar = Calendar.current
        var images: [Date: String] = [:]
        
        for i in 0..<days {
            if i % interval == 0 {
                let date = calendar.date(byAdding: .day, value: -i, to: Date())!
                let normalizedDate = calendar.startOfDay(for: date)
                images[normalizedDate] = "\(prefix)\(i).jpg"
            }
        }
        
        return images
    }
    
    /// 특정 날짜들에 사진이 있는 Mock 데이터 생성
    /// - Parameters:
    ///   - dayOffsets: 오늘부터 몇 일 전인지 배열 (예: [0, 1, 3, 7])
    ///   - prefix: 파일명 접두사
    /// - Returns: [Date: String] 형태의 이미지 맵
    static func specificDateImages(
        dayOffsets: [Int],
        filePrefix prefix: String = "photo_"
    ) -> [Date: String] {
        let calendar = Calendar.current
        var images: [Date: String] = [:]
        
        for offset in dayOffsets {
            let date = calendar.date(byAdding: .day, value: -offset, to: Date())!
            let normalizedDate = calendar.startOfDay(for: date)
            images[normalizedDate] = "\(prefix)\(offset).jpg"
        }
        
        return images
    }
}

struct CalendarMockData {
    private init() {} // 인스턴스 생성 방지
}
