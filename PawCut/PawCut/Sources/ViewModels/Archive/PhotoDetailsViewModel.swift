//
//  PhotoDetailsViewModel.swift
//  PawCut
//
//  Created by taeni on 8/17/25.
//

import SwiftUI
import SwiftData

@MainActor
final class PhotoDetailsViewModel: ObservableObject {
    
    private var modelContext: ModelContext?
    private let imageFileManager = ImageFileManager.shared
    
    @Published var groupedPhotos: [Date: [Photo]] = [:]
    @Published var currentDate: Date = Date()
    @Published var currentIndex: Int = 0
    
    @Published var showDeleteConfirmation: Bool = false
    @Published var showToast: Bool = false
    @Published var toastMessage: String = ""
    
    init(initialDate: Date = Date(), initialIndex: Int = 0) {
        self.currentDate = initialDate.startOfDay
        self.currentIndex = initialIndex
    }
    
    var sortedDates: [Date] {
        groupedPhotos.keys.sorted(by: <)
    }
    
    var currentPhotos: [Photo] {
        return groupedPhotos[currentDate.startOfDay] ?? []
    }
    
    var currentPhoto: Photo? {
        guard currentIndex >= 0, currentIndex < currentPhotos.count else { return nil }
        return currentPhotos[currentIndex]
    }
    
    func setupModelContext(_ context: ModelContext) {
        self.modelContext = context
        loadPhotosFromDatabase()
    }
    
    func saveCurrentImage() {
        guard let currentPhoto = currentPhoto else { return }
        
        Task {
            do {
                guard let image = await imageFileManager.loadImage(fileName: currentPhoto.fileName) else {
                    await MainActor.run {
                        showToastMessage("이미지를 불러올 수 없습니다")
                        HapticManager.shared.triggerError()
                    }
                    return
                }
                
                try await imageFileManager.saveToPhotoLibrary(image: image)
                
                await MainActor.run {
                    showToastMessage("사진이 저장되었습니다")
                    HapticManager.shared.triggerSaveComplete()
                }
                
            } catch {
                await MainActor.run {
                    showToastMessage("사진 저장에 실패했습니다")
                    HapticManager.shared.triggerError()
                }
            }
        }
    }
    
    func deleteCurrentImage() {
        guard let currentPhoto = currentPhoto else { return }
        
        Task {
            await deletePhoto(currentPhoto)
        }
    }
    
    private func showToastMessage(_ message: String) {
        toastMessage = message
        showToast = true
    }
}

// TODO: SwiftData 처리
// PhotoDetailsViewModel, ArchiveViewModel 로직이 중복되므로 추후 통일 해야함
extension PhotoDetailsViewModel {
    
    func loadPhotosFromDatabase() {
        guard let modelContext = modelContext else { return }
        
        Task {
            do {
                let descriptor = FetchDescriptor<Photo>(
                    sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
                )
                let allPhotos = try modelContext.fetch(descriptor)
                
                await MainActor.run {
                    let calendar = Calendar.current
                    var newGroupedPhotos: [Date: [Photo]] = [:]
                    
                    for photo in allPhotos {
                        let dayKey = calendar.startOfDay(for: photo.createdAt)
                        if newGroupedPhotos[dayKey] == nil {
                            newGroupedPhotos[dayKey] = []
                        }
                        newGroupedPhotos[dayKey]?.append(photo)
                    }
                    
                    self.groupedPhotos = newGroupedPhotos
                    self.updateCurrentPhotosAndIndex()
                }
                
            } catch {
                await MainActor.run {
                    print("사진 로딩 실패: \(error)")
                }
            }
        }
    }
    
    private func updateCurrentPhotosAndIndex() {
        let normalizedCurrentDate = currentDate.startOfDay
        
        if groupedPhotos[normalizedCurrentDate]?.isEmpty != false {
            if let latestDate = sortedDates.last {
                currentDate = latestDate
                currentIndex = 0
            }
        }
        
        let photosCount = currentPhotos.count
        if currentIndex >= photosCount {
            currentIndex = max(0, photosCount - 1)
        }
    }
    
    func deletePhoto(_ photo: Photo) async {
        guard let modelContext = modelContext else { return }
        
        do {
            // 실제 파일 삭제
            try await imageFileManager.deleteFile(fileName: photo.fileName)
            
            // SwiftData 삭제
            modelContext.delete(photo)
            try modelContext.save()
            
            await MainActor.run {
                loadPhotosFromDatabase()
                showToastMessage("사진이 삭제되었습니다.")
                HapticManager.shared.triggerSuccess()
            }
        } catch {
            await MainActor.run {
                showToastMessage("사진 삭제에 실패했습니다.")
                HapticManager.shared.triggerError()
            }
        }
    }
}
