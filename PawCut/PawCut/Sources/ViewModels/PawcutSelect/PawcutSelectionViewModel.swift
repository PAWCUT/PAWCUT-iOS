import SwiftUI

@MainActor
class PawcutSelectionViewModel: ObservableObject {
    private let navigationManager = NavigationManager.shared
    
    func tapNextButton() {
        navigationManager.navigate(to: .pawcutImageSelection(.pawcutFrameSelection))
    }
}


