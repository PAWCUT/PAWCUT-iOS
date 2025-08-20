//
//  ImageQuality.swift
//  PawCut
//
//  Created by taeni on 8/19/25.
//
import Foundation

enum ImageQuality {
    case originally     // 1.0  - 아카이브용 최고 품질
    case standard       // 0.85 - 일반 갤러리용 균형
    case thumbnail      // 0.7  - 썸네일용 빠른 로딩
    case network        // 0.6  - 네트워크 전송용 속도 우선
    case custom(CGFloat) // 사용자 정의
    
    var compressionValue: CGFloat {
        switch self {
        case .originally:
            return 1.0
        case .standard:
            return 0.85
        case .thumbnail:
            return 0.7
        case .network:
            return 0.6
        case .custom(let value):
            return max(0.1, min(1.0, value))
        }
    }
}
