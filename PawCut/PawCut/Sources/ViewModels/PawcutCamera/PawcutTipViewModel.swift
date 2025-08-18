//
//  PawcutTipViewModel.swift
//  PawCut
//
//  Created by Luminouxx on 8/18/25.
//

import Foundation

@MainActor
class PawcutTipViewModel: ObservableObject {
    
    private let navigationManager = NavigationManager.shared
    
    func tapBackButton() {
        navigationManager.pop()
    }
    
    func tapNextButton() {
        // TODO: 화면 전환 구현
    }
}
