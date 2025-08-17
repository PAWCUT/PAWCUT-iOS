import SwiftUI

@MainActor
class PawcutSelectionViewModel: ObservableObject {
    private let navigationManager = NavigationManager.shared
    
    func tapNextButton() {
        navigationManager.navigate(to: .main(.pawcutFrameSelection))
    }
    
    func tapBackButton() {
        navigationManager.pop()
    }
}


