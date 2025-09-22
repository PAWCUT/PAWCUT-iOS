//
//  PawcutTipViewModel.swift
//  PawCut
//
//  Created by Luminouxx on 8/18/25.
//

import Foundation

struct TipData {
    let iconName: String
    let message: String
}

@MainActor
class PawcutTipViewModel: ObservableObject {
    
    private let navigationManager = NavigationManager.shared
    
    let tips: [TipData] = [
        TipData(iconName: "ic_tip_camera", message: "'촬영하기'를 누르면 바로 촬영이 시작돼요."),
        TipData(iconName: "ic_tip_clock", message: "6초 타이머가 자동으로 작동해요."),
        TipData(iconName: "ic_tip_picture", message: "사진은 기본으로 8장이 연속 촬영돼요."),
        TipData(iconName: "ic_tip_hand", message: "설정에서 카메라 접근을 먼저 허용해 주세요."),
        TipData(iconName: "ic_tip_arrow", message: "뒤로가기 버튼으로 촬영을 중단할 수 있어요."),
        TipData(iconName: "ic_camera_sound", message: "음성을 통해 강아지의 시선을 집중시켜 보세요.")
    ]
    
    func tapBackButton() {
        navigationManager.pop()
    }
    
    func tapNextButton() {
        navigationManager.navigate(to: .main(.ready))
    }
}
