import SwiftUI

@MainActor
class PawcutSelectionViewModel: ObservableObject {
    private let navigationManager = NavigationManager.shared

    @Published private(set) var sourceImages: [UIImage]
    @Published private(set) var selectedIndices: [Int] = []

    @Published var showBackAlert = false

    let maxSelection = 4

    var selectedCount: Int { selectedIndices.count }
    var sourceImagesCount: Int { sourceImages.count }
    var selectedImagesInOrder: [UIImage] {
        selectedIndices.map { sourceImages[$0] }
    }

    init(sourceImages: [UIImage]) {
        self.sourceImages = sourceImages
    }

    func toggleSelection(at index: Int) {
        if let i = selectedIndices.firstIndex(of: index) {
            // 이미 선택되어 있으면 해제
            selectedIndices.remove(at: i)
        } else {
            // 새로 선택 — 최대 개수 제한
            guard selectedIndices.count < maxSelection else { return }
            selectedIndices.append(index)
        }
    }

    func isSelected(_ index: Int) -> Bool {
        selectedIndices.contains(index)
    }

    func selectionOrder(_ index: Int) -> Int? {
        selectedIndices.firstIndex(of: index).map { $0 + 1 }  // 1부터 보이게
    }

    func tapNextButton() {
        if selectedCount == 4 {
            navigationManager.navigate(
                to: .main(.pawcutFrameSelection(images: selectedImagesInOrder))
            )
        }
    }

    func tapBackButton() {
        
        navigationManager.popUntil(to: 3)
    }

    func requestBackNavigation() {
        showBackAlert = true
    }

    func confirmBackNavigation() {
        tapBackButton()
    }
}
