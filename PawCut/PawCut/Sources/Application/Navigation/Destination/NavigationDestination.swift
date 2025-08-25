//
//  NavigationDestination.swift
//  PawCut
//
//  Created by Luminouxx on 8/11/25.
//

import SwiftUI

protocol NavigationDestination: Hashable {
    associatedtype ViewType: View
    @ViewBuilder func view() -> ViewType
}

enum AppDestination: Hashable {
    case onboarding(OnboardingDestination)
    case main(MainDestination)
}

extension AppDestination {
    @ViewBuilder
    func view() -> some View {
        switch self {
        case .onboarding(let destination):
            destination.view()
        case .main(let destination):
            destination.view()
        }
    }
}
