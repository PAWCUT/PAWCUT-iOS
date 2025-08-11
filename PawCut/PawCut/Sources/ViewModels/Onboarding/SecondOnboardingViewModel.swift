//
//  SecondOnboardingViewModel.swift
//  PawCut
//
//  Created by Luminouxx on 8/11/25.
//

import Foundation

@MainActor
class SecondOnboardingViewModel: ObservableObject {
    
    private let navigationManager = NavigationManager.shared
    
    let currentPage: Int = 1
    
    func tapNextButton() {
        navigationManager.navigate(to: .onboarding(.thirdOnboarding))
    }
}
