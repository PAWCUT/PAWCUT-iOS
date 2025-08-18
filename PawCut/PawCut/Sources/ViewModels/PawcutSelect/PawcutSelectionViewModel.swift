import SwiftUI

@MainActor
class PawcutSelectionViewModel: ObservableObject {
    private let navigationManager = NavigationManager.shared
    
    // 1) 원본 썸네일 소스 (촬영/앨범에서 로드)
    @Published private(set) var sourceImages: [UIImage] = []
    
    // 2) 선택된 인덱스들(선택 순서 보존) — 최대 4장
    @Published private(set) var selectedIndices: [Int] = []
    let maxSelection = 4

    // 3) UI 바인딩용 계산 프로퍼티
    var selectedCount: Int { selectedIndices.count }
    var sourceImagesCount: Int { sourceImages.count }
    var selectedImagesInOrder: [UIImage] {
        selectedIndices.map { sourceImages[$0] }
    }
    
    // MARK: - Public API
    func setSources(_ images: [UIImage]) {
        sourceImages = images
        selectedIndices.removeAll()
    }
    
    func toggleSelection(at index: Int) {
        guard sourceImages.indices.contains(index) else { return }
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
        selectedIndices.firstIndex(of: index).map { $0 + 1 } // 1부터 보이게
    }
    
    // 네비게이션
    func tapNextButton() {
        // 필요하다면 최소 선택 개수 검증
        // guard selectedCount == maxSelection else { return }
        navigationManager.navigate(to: .main(.pawcutFrameSelection))
    }
    
    func tapBackButton() {
        navigationManager.pop()
    }
}
