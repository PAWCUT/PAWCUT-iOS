//
//  ThirdOnboardingViewModel.swift
//  PawCut
//
//  Created by Luminouxx on 8/11/25.
//

import Foundation

@MainActor
class ThirdOnboardingViewModel: ObservableObject {
    
    private let navigationManager = NavigationManager.shared
    
    let currentPage: Int = 2
    
    func tapNextButton() {
        // TODO: 아직 미정되었기 때문에, 추후 수정
        navigationManager.navigate(to: .main(.home))
    }
}
