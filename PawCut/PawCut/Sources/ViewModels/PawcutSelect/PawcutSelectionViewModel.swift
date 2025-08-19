import SwiftUI

@MainActor
class PawcutSelectionViewModel: ObservableObject {
    private let navigationManager = NavigationManager.shared
    
    @Published var capturedImages: [UIImage] = []
    
    init() {
        loadImagesFromUserDefaults()
    }
    
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


