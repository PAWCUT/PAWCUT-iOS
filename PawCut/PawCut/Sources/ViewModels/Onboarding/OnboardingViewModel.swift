//
//  OnboardingViewModel.swift
//  PawCut
//
//  Created by donghee on 8/16/25.
//

import Foundation
import SwiftUI

@MainActor
class OnboardingViewModel: ObservableObject {

    @Published var currentPage: Int = 0

    private let navigationManager = NavigationManager.shared
    private let totalPages = 3

    func tapNextButton() {
        if currentPage < totalPages - 1 {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentPage += 1
            }
        } else {
            navigationManager.navigate(to: .onboarding(.petInfo))
        }
    }
}