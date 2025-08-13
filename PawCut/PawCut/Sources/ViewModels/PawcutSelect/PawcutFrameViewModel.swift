import SwiftUI

@MainActor
class PawcutFrameViewModel: ObservableObject {
    private let navigationManager = NavigationManager.shared
    
    func tapNextButton() {
        navigationManager.navigate(to: .pawcutImageSelection(.pawcutFrameSelection))
    }
    
    func tapBackButton() {
        navigationManager.pop()
    }
}


