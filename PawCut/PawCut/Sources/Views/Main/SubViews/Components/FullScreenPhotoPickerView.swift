//
//  FullScreenPhotoPickerView.swift
//  PawCut
//
//  Created by Jay on 10/23/25.
//

import PhotosUI
import SwiftUI

struct FullScreenPhotoPickerView: UIViewControllerRepresentable {
    var onPick: ([UIImage]) -> Void
    @Environment(\.dismiss) private var dismiss

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 8

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        picker.modalPresentationStyle = .fullScreen
        return picker
    }

    func updateUIViewController(
        _ uiViewController: PHPickerViewController,
        context: Context
    ) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: FullScreenPhotoPickerView
        init(_ parent: FullScreenPhotoPickerView) { self.parent = parent }

        func picker(
            _ picker: PHPickerViewController,
            didFinishPicking results: [PHPickerResult]
        ) {
            guard !results.isEmpty else {
                parent.dismiss()
                return
            }

            var images: [UIImage] = []
            let group = DispatchGroup()

            for result in results {
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    group.enter()
                    result.itemProvider.loadObject(ofClass: UIImage.self) {
                        object,
                        _ in
                        if let image = object as? UIImage {
                            images.append(image)
                        }
                        group.leave()
                    }
                }
            }

            group.notify(queue: .main) {
                self.parent.onPick(images)
                self.parent.dismiss()
            }
        }
    }
}
