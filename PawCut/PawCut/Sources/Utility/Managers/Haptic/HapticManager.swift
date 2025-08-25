//
//  HapticType.swift
//  PawCut
//
//  Created by taeni on 8/17/25.
//

import UIKit

// MARK: - Haptic Types
enum HapticType {
    case light
    case medium
    case heavy
    case selection
    case success
    case warning
    case error
}

// MARK: - HapticManager
final class HapticManager {
    
    // MARK: - Singleton
    static let shared = HapticManager()
    
    // MARK: - Properties
    private var isHapticEnabled: Bool = true
    private var lastHapticTime: CFTimeInterval = 0
    private let hapticThreshold: CFTimeInterval = 0.1 // 100ms 간격으로 햅틱 제한
    
    // MARK: - Haptic Generators
    private lazy var lightImpactGenerator = UIImpactFeedbackGenerator(style: .light)
    private lazy var mediumImpactGenerator = UIImpactFeedbackGenerator(style: .medium)
    private lazy var heavyImpactGenerator = UIImpactFeedbackGenerator(style: .heavy)
    private lazy var selectionGenerator = UISelectionFeedbackGenerator()
    private lazy var notificationGenerator = UINotificationFeedbackGenerator()
    
    private init() {
        prepareGenerators()
    }
    
    // MARK: - Public Methods
    
    /// 햅틱 피드백 실행
    /// - Parameter type: 햅틱 타입
    func trigger(_ type: HapticType) {
        guard isHapticEnabled && canTriggerHaptic() else { return }
        
        switch type {
        case .light:
            lightImpactGenerator.impactOccurred()
        case .medium:
            mediumImpactGenerator.impactOccurred()
        case .heavy:
            heavyImpactGenerator.impactOccurred()
        case .selection:
            selectionGenerator.selectionChanged()
        case .success:
            notificationGenerator.notificationOccurred(.success)
        case .warning:
            notificationGenerator.notificationOccurred(.warning)
        case .error:
            notificationGenerator.notificationOccurred(.error)
        }
        
        updateLastHapticTime()
    }
    
    /// 햅틱 활성화/비활성화 설정
    /// - Parameter enabled: 햅틱 사용 여부
    func setHapticEnabled(_ enabled: Bool) {
        isHapticEnabled = enabled
    }
    
    /// 햅틱 활성화 상태 확인
    /// - Returns: 햅틱 활성화 여부
    func isEnabled() -> Bool {
        return isHapticEnabled
    }
    
    // MARK: - Convenience Methods
    
    /// 썸네일 스크롤 시 사용할 가벼운 햅틱
    func triggerThumbnailScroll() {
        trigger(.light)
    }
    
    /// 버튼 선택 시 사용할 햅틱
    func triggerSelection() {
        trigger(.selection)
    }
    
    /// 성공 액션 시 사용할 햅틱
    func triggerSuccess() {
        trigger(.success)
    }
    
    /// 삭제 등 중요한 액션 시 사용할 햅틱
    func triggerMediumImpact() {
        trigger(.medium)
    }
    
    /// 경고 상황에서 사용할 햅틱
    func triggerWarning() {
        trigger(.warning)
    }
    
    /// 에러 상황에서 사용할 햅틱
    func triggerError() {
        trigger(.error)
    }
    
    // MARK: - Private Methods
    
    /// 햅틱 생성기들을 미리 준비
    private func prepareGenerators() {
        lightImpactGenerator.prepare()
        mediumImpactGenerator.prepare()
        heavyImpactGenerator.prepare()
        selectionGenerator.prepare()
        notificationGenerator.prepare()
    }
    
    /// 햅틱 실행 가능 여부 확인 (중복 방지)
    private func canTriggerHaptic() -> Bool {
        let currentTime = CACurrentMediaTime()
        return currentTime - lastHapticTime >= hapticThreshold
    }
    
    /// 마지막 햅틱 시간 업데이트
    private func updateLastHapticTime() {
        lastHapticTime = CACurrentMediaTime()
    }
}

// MARK: - HapticManager Extension for UI Components
extension HapticManager {
    
    /// 스크롤 기반 인덱스 변경 시 햅틱
    /// - Parameters:
    ///   - currentIndex: 현재 인덱스
    ///   - lastHapticIndex: 마지막 햅틱이 실행된 인덱스
    /// - Returns: 업데이트된 lastHapticIndex
    func triggerScrollIndexChange(currentIndex: Int, lastHapticIndex: inout Int) {
        guard currentIndex != lastHapticIndex else { return }
        
        triggerThumbnailScroll()
        lastHapticIndex = currentIndex
    }
    
    /// 페이지 전환 시 햅틱
    func triggerPageTransition() {
        trigger(.medium)
    }
    
    /// 이미지 삭제 확인 시 햅틱
    func triggerDeleteConfirmation() {
        trigger(.warning)
    }
    
    /// 이미지 저장 완료 시 햅틱
    func triggerSaveComplete() {
        trigger(.success)
    }
}
