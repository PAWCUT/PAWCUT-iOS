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
    
    // MARK: 최신순 정렬
    var sortedDates: [Date] {
        // 최신순(내림차순) 정렬로 통일
        groupedPhotos.keys.sorted(by: >)
    }
    
    var currentPhotos: [Photo] {
        return groupedPhotos[currentDate.startOfDay] ?? []
    }
    
    var currentPhoto: Photo? {
        guard currentIndex >= 0, currentIndex < currentPhotos.count else { return nil }
        return currentPhotos[currentIndex]
    }
    
    init(modelContext: ModelContext? = nil) {
        // currentDate를 startOfDay로 정규화
        self.currentDate = Date().startOfDay
        print(currentDate.koreanYearMonthDateString)
        self.modelContext = modelContext
    }
    
    func setupModelContext(_ context: ModelContext) {
        self.modelContext = context
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
    
    
    // 현재 이미지 삭제
    func deleteCurrentImage() {
        guard let currentPhoto = currentPhoto else { return }
        
        Task {
            do {
                try await imageFileManager.deleteFile(fileName: currentPhoto.fileName)
                
                await MainActor.run {
                    updateAfterDeletion()
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
    
    /// 삭제 후 UI 업데이트
    private func updateAfterDeletion() {
        let normalizedCurrentDate = currentDate.startOfDay
        
        // 현재 날짜의 사진 목록 업데이트
        var updatedPhotos = groupedPhotos[normalizedCurrentDate] ?? []
        if currentIndex < updatedPhotos.count {
            updatedPhotos.remove(at: currentIndex)
        }
        
        if updatedPhotos.isEmpty {
            // 현재 날짜에 더 이상 사진이 없으면 날짜 제거
            groupedPhotos.removeValue(forKey: normalizedCurrentDate)
            
            // 다른 날짜로 이동
            if !sortedDates.isEmpty {
                currentDate = sortedDates.first!.startOfDay
                currentIndex = 0
            }
        } else {
            // 현재 날짜 사진 목록 업데이트
            groupedPhotos[normalizedCurrentDate] = updatedPhotos
            
            // 인덱스 조정
            if currentIndex >= updatedPhotos.count {
                currentIndex = max(0, updatedPhotos.count - 1)
            }
        }
    }
    
    /// 현재 사진과 인덱스 업데이트
    func updateCurrentPhotosAndIndex() {
        let normalizedCurrentDate = currentDate.startOfDay
        let photos = groupedPhotos[normalizedCurrentDate] ?? []
        
        if photos.isEmpty {
            // 현재 날짜에 사진이 없으면 가장 최근 날짜로 이동
            if let firstDate = sortedDates.first,
               let firstDatePhotos = groupedPhotos[firstDate.startOfDay], !firstDatePhotos.isEmpty {
                currentDate = firstDate.startOfDay
                currentIndex = 0
            }
        } else if currentIndex >= photos.count {
            currentIndex = max(0, photos.count - 1)
        }
    }
    
    private func showToastMessage(_ message: String) {
        toastMessage = message
        showToast = true
    }
}
