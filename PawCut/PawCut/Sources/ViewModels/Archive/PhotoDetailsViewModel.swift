//
//  PhotoDetailsViewModel.swift
//  PawCut
//
//  Created by taeni on 8/17/25.
//

import SwiftUI
import SwiftData
import Photos

@MainActor
final class PhotoDetailsViewModel: ObservableObject {
    
    @Published private(set) var groupedPhotos: [Date: [Photo]] = [:]
    @Published var currentDate: Date
    @Published var currentIndex: Int
    @Published var showDeleteConfirmation: Bool = false
    @Published var showToast: Bool = false
    @Published var toastMessage: String = ""
    
    private var modelContext: ModelContext?
    private let imageFileManager = ImageFileManager.shared
    private let navigationManager = NavigationManager.shared
    
    var sortedDates: [Date] {
        groupedPhotos.keys.sorted(by: <)
    }
    
    var currentPhotos: [Photo] {
        groupedPhotos[currentDate.startOfDay] ?? []
    }
    
    var currentPhoto: Photo? {
        guard currentIndex >= 0, currentIndex < currentPhotos.count else { return nil }
        return currentPhotos[currentIndex]
    }
    
    init(initialDate: Date, initialIndex: Int) {
        self.currentDate = initialDate.startOfDay
        self.currentIndex = initialIndex
    }
    
    func willSetupModelContext(_ context: ModelContext) {
        self.modelContext = context
        loadPhotosFromDatabase()
    }
    
    func didTapSavePhoto() {
        guard let currentPhoto = currentPhoto else { return }
        savePhotoToLibrary(currentPhoto)
    }
    
    func didTapDeletePhoto() {
        showDeleteConfirmation = true
    }
    
    func didConfirmDeletePhoto() {
        guard let currentPhoto = currentPhoto else { return }
        deletePhoto(currentPhoto)
    }
    
    func didTapBackButton() {
        navigateBack()
    }
    
    func didUpdatePhotoPosition(date: Date, index: Int) {
        currentDate = date
        currentIndex = index
    }
    
    func didTapThumbnail(at index: Int) {
        triggerHaptic(.selection)
        currentIndex = index
    }
    
    func didSwipeToNextImage() {
        moveToNextImage()
    }
    
    func didSwipeToPreviousImage() {
        moveToPreviousImage()
    }
}

private extension PhotoDetailsViewModel {
    func navigateBack() {
        navigationManager.pop()
    }
}

private extension PhotoDetailsViewModel {
    func savePhotoToLibrary(_ photo: Photo) {
        Task {
            do {
                let authStatus = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
                let permissionStatus = PhotoPermissionStatus(from: authStatus)
                
                guard permissionStatus.canSavePhoto else {
                    await handleResult(message: permissionStatus.userMessage, haptic: .error)
                    return
                }
                
                guard let image = await imageFileManager.loadImage(fileName: photo.fileName) else {
                    await handleResult(message: "사진을 불러올 수 없어요.", haptic: .error)
                    return
                }
                
                try await imageFileManager.saveToPhotoLibrary(image: image)
                await handleResult(message: "저장이 완료되었어요.", haptic: .success)
            } catch {
                await handleResult(message: "저장에 실패했어요.", haptic: .error)
            }
        }
    }
    
    func deletePhoto(_ photo: Photo) {
        Task {
            await performDelete(photo)
        }
    }
    
    private func performDelete(_ photo: Photo) async {
        guard let modelContext = modelContext else { return }
        
        do {
            try await imageFileManager.deleteFile(fileName: photo.fileName)
            modelContext.delete(photo)
            try modelContext.save()
            
            loadPhotosFromDatabase()
            await handleResult(message: "사진이 삭제되었어요.", haptic: .success)
        } catch {
            await handleResult(message: "사진을 삭제할 수 없어요.", haptic: .error)
        }
    }
    
    // TODO: SwiftData 로직 구현 필요
    func loadPhotosFromDatabase() {
        guard let modelContext = modelContext else { return }
        
        Task {
            do {
                let descriptor = FetchDescriptor<Photo>(sortBy: [SortDescriptor(\.createdAt, order: .forward)])
                let allPhotos = try modelContext.fetch(descriptor)
                
                let calendar = Calendar.current
                var newGroupedPhotos: [Date: [Photo]] = [:]
                
                for photo in allPhotos {
                    let dayKey = calendar.startOfDay(for: photo.createdAt)
                    if newGroupedPhotos[dayKey] == nil {
                        newGroupedPhotos[dayKey] = []
                    }
                    newGroupedPhotos[dayKey]?.append(photo)
                }
                
                groupedPhotos = newGroupedPhotos
                willUpdateCurrentPhotosAndIndex()
                
                if groupedPhotos.isEmpty {
                    navigateBack()
                }
            } catch {
                await handleResult(message: "사진 목록을 불러오지 못했어요.", haptic: .error)
            }
        }
    }
    
    func willUpdateCurrentPhotosAndIndex() {
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
    
    func getAllPhotos() -> [Photo] {
        sortedDates.flatMap { groupedPhotos[$0.startOfDay] ?? [] }
    }
}

private extension PhotoDetailsViewModel {
    func moveToNextImage() {
        let allPhotos = getAllPhotos()
        
        if let currentPhoto = currentPhoto,
           let currentAllIndex = allPhotos.firstIndex(where: { $0.id == currentPhoto.id }),
           currentAllIndex < allPhotos.count - 1 {
            let nextPhoto = allPhotos[currentAllIndex + 1]
            let nextDate = nextPhoto.createdAt.startOfDay
            let nextIndexInDate = groupedPhotos[nextDate]?.firstIndex(where: { $0.id == nextPhoto.id }) ?? 0
            
            currentDate = nextDate
            currentIndex = nextIndexInDate
            
            triggerHaptic(.selection)
        }
    }
    
    func moveToPreviousImage() {
        let allPhotos = getAllPhotos()
        
        if let currentPhoto = currentPhoto,
           let currentAllIndex = allPhotos.firstIndex(where: { $0.id == currentPhoto.id }),
           currentAllIndex > 0 {
            let previousPhoto = allPhotos[currentAllIndex - 1]
            let previousDate = previousPhoto.createdAt.startOfDay
            let previousIndexInDate = groupedPhotos[previousDate]?.firstIndex(where: { $0.id == previousPhoto.id }) ?? 0
            
            currentDate = previousDate
            currentIndex = previousIndexInDate
            
            triggerHaptic(.selection)
        }
    }
}

private extension PhotoDetailsViewModel {
    enum HapticType {
        case success
        case selection
        case error
    }
    
    func triggerHaptic(_ type: HapticType) {
        switch type {
        case .success: HapticManager.shared.triggerSuccess()
        case .selection: HapticManager.shared.triggerSelection()
        case .error: HapticManager.shared.triggerError()
        }
    }
    
    func showToastMessage(_ message: String) {
        toastMessage = message
        showToast = true
    }
    
    func handleResult(message: String, haptic: HapticType) async {
        await MainActor.run {
            showToastMessage(message)
            triggerHaptic(haptic)
        }
    }
}
