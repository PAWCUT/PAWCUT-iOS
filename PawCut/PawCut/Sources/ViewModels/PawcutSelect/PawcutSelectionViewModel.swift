import SwiftUI

@MainActor
class PawcutSelectionViewModel: ObservableObject {
    private let navigationManager = NavigationManager.shared
    
    @Published private(set) var sourceImages: [UIImage] = []
    @Published private(set) var selectedIndices: [Int] = []
    @Published var capturedImages: [UIImage] = []
    
    let maxSelection = 4

    var selectedCount: Int { selectedIndices.count }
    var sourceImagesCount: Int { sourceImages.count }
    var selectedImagesInOrder: [UIImage] {
        selectedIndices.map { sourceImages[$0] }
    }
    
    init() {
        loadImagesFromUserDefaults()

    }  
  
    func loadMockData() {
        var imgs: [UIImage] = []
        for _ in 0..<8 {
            if let ui = UIImage(named: "save_cat") {
                imgs.append(ui)
            }
        }
        sourceImages = imgs
        selectedIndices.removeAll()
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
        selectedIndices.firstIndex(of: index).map { $0 + 1 } // 1부터 보이게
    
    
    func tapNextButton() {
        navigationManager.navigate(to: .main(.pawcutFrameSelection))
    }
    
    func tapBackButton() {
        navigationManager.pop()
    }
    
    private func loadImagesFromUserDefaults() {
        guard let imageDataArray = UserDefaults.standard.array(forKey: "captured_photos") as? [Data] else {
            return
        }
        
        capturedImages = imageDataArray.compactMap { data in
            UIImage(data: data)
        }
    }
}
