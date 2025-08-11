//
//  NavigationManager.swift
//  PawCut
//
//  Created by Luminouxx on 8/11/25.
//

import SwiftUI

@MainActor
class NavigationManager: ObservableObject {
    static let shared = NavigationManager()
    
    @Published var path = NavigationPath()
    @Published private(set) var hasCompletedOnboarding: Bool
    
    private init() {
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    }
    
    func navigate(to destination: AppDestination) {
        path.append(destination)
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func reset(to destination: AppDestination) {
        popToRoot()
        navigate(to: destination)
    }
    
    @ViewBuilder
    func getRootView() -> some View {
        if hasCompletedOnboarding {
            MainDestination.home.view()
        } else {
            OnboardingDestination.firstOnboarding.view()
        }
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        reset(to: .main(.home))
    }
    
    func restartOnboarding() {
        hasCompletedOnboarding = false
        UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
        reset(to: .onboarding(.firstOnboarding))
    }
}
