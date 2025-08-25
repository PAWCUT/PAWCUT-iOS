import SwiftUI

@MainActor
class PawcutFrameViewModel: ObservableObject {
    private let navigationManager = NavigationManager.shared

    @Published var selectedImages: [UIImage]
    @Published var isBottomSheetPresented = false
    @Published var selectedFrameIndex: Int? = nil
    
    init(selectedImages: [UIImage]) {
        self.selectedImages = selectedImages
    }
    
    var frameScrollImageNames: [String] = [
        "snow_scroll", "ink_scroll", "cobalt_scroll", "peek_scroll",
        "heart_scroll", "cloud_scroll", "blush_scroll", "wave_scroll",
        "sparkle_scroll", "dawn_scroll", "bloom_scroll", "breeze_scroll",
        "blue_scroll", "ginkgo_scroll",
    ]
    
    var frameImageNames: [String] = [
        "snow_frame", "ink_frame", "cobalt_frame", "peek_frame", "heart_frame",
        "cloud_frame", "blush_frame", "wave_frame", "sparkle_frame",
        "dawn_frame", "bloom_frame", "breeze_frame", "blue_frame",
        "ginkgo_frame",
    ]

    var selectedFrameDisplayName: String? {
        guard let index = selectedFrameIndex else { return nil }
        let name = frameScrollImageNames[index].replacingOccurrences(
            of: "_scroll",
            with: ""
        )
        return name.prefix(1).uppercased() + name.dropFirst()
    }

    var selectedFrameImage: UIImage? {
        guard let index = selectedFrameIndex else { return nil }
        return UIImage(named: frameImageNames[index])
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
}
