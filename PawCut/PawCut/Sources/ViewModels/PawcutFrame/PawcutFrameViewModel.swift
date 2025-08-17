import SwiftUI

@MainActor
class PawcutFrameViewModel: ObservableObject {
    private let navigationManager = NavigationManager.shared
    
    @Published var selectedImages: [UIImage] = []
    @Published var selectedFrame: [UIImage] = []
    @Published var isBottomSheetPresented = false
    
    func tapBackButton() {
        navigationManager.pop()
    }
}


