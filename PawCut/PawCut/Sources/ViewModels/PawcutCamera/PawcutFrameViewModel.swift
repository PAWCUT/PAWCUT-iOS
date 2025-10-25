import SwiftUI

@MainActor
class PawcutFrameViewModel: ObservableObject {
    private let navigationManager = NavigationManager.shared
    @Published var selectedImages: [UIImage]
    @Published var isBottomSheetPresented = false
    @Published var selectedFrameIndex: Int? = nil

    let frames = FrameType.sortedCases

    init(selectedImages: [UIImage]) {
        self.selectedImages = selectedImages
    }

    var selectedFrame: FrameType? {
        guard let index = selectedFrameIndex else {return nil}
        return frames[index]
    }
    
    var selectedFrameDisplayName: String? {
        selectedFrame?.displayName
    }

    var selectedFrameImage: UIImage? {
        selectedFrame.flatMap { UIImage(named: $0.frameImageName) }
    }

    func tapBackButton() {
        navigationManager.pop()
    }

    func tapHomeButton() {
        navigationManager.popToRoot()
    }

    func tapCancelButton() {
        isBottomSheetPresented = false
    }

    func selectDefaultFrameIfNeeded() {
        if selectedFrameIndex == nil {
            selectedFrameIndex = 0
        }
    }
}
