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
                // 권한 확인
                let authStatus = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
                let permissionStatus = PhotoPermissionStatus(from: authStatus)
                
                // 권한이 없으면 toast
                guard permissionStatus.canSavePhoto else {
                    await MainActor.run {
                        showToastMessage(permissionStatus.userMessage)
                        HapticManager.shared.triggerError()
                    }
                    return
                }
                
                // 권한이 있으면 이미지 로드 시도
                guard let image = await imageFileManager.loadImage(fileName: currentPhoto.fileName) else {
                    await MainActor.run {
                        showToastMessage("사진을 불러올 수 없어요.")
                        HapticManager.shared.triggerError()
                    }
                    return
                }
                
                // 저장 시도
                try await imageFileManager.saveToPhotoLibrary(image: image)
                
                await MainActor.run {
                    showToastMessage("저장이 완료되었어요.")
                    HapticManager.shared.triggerSaveComplete()
                }
                
            } catch {
                await MainActor.run {
                    showToastMessage("저장에 실패했어요.")
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

// TODO: SwiftData 처리를 extension 으로 해둠. 추후 처리 필요
extension PhotoDetailsViewModel {
    
    func loadPhotosFromDatabase() {
        guard let modelContext = modelContext else {
            return
        }
        
        Task {
            do {
                let descriptor = FetchDescriptor<Photo>(
                    sortBy: [SortDescriptor(\.createdAt, order: .forward)]
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
                    
                    if self.groupedPhotos.isEmpty {
                        NavigationManager.shared.pop()
                    }
                    
                    HapticManager.shared.triggerSuccess()
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
            // 1. 파일 삭제
            try await imageFileManager.deleteFile(fileName: photo.fileName)
            
            // SwiftData에서 삭제
            modelContext.delete(photo)
            try modelContext.save()
            
            await MainActor.run {
                
                self.showToastMessage("사진이 삭제되었어요.")
                // 갱신
                loadPhotosFromDatabase()
                HapticManager.shared.triggerSuccess()
            }
        } catch {
            await MainActor.run {
                showToastMessage("사진을 삭제할 수 없어요.")
                HapticManager.shared.triggerError()
            }
        }
    }
}
