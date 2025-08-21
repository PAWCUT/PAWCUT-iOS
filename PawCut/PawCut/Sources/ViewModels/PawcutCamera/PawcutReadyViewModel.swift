//
//  PawcutReadyViewModel.swift
//  PawCut
//
//  Created by Luminouxx on 8/21/25.
//

import Foundation

@MainActor
class PawcutReadyViewModel: ObservableObject {
    
    private let navigationManager = NavigationManager.shared
    
    func tapBackButton() {
        navigationManager.pop()
    }
    
    func moveToNext() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.navigationManager.navigate(to: .main(.camera))
        }
    }
}
