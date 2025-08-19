//
//  SoundSettingViewModel.swift
//  PawCut
//
//  Created by donghee on 8/19/25.
//

import Foundation

@MainActor
class SoundSettingViewModel: ObservableObject {
    @Published var selectedSoundIndex: Int = 0
    
    let soundNames = ["벨소리", "벨소리", "벨소리", "벨소리", "벨소리", "벨소리"]
    
    func selectSound(at index: Int) {
        selectedSoundIndex = index
        // TODO: 사운드 재생 기능 추가
        playSound(at: index)
    }
    
    private func playSound(at index: Int) {
        // TODO: 실제 사운드 재생 로직 구현
        print("Playing sound at index: \(index)")
    }
    
    func saveSelection() {
        // TODO: 선택된 사운드 저장 로직
        print("Saved sound at index: \(selectedSoundIndex)")
    }
}