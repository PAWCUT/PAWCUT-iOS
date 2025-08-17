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
    
    @Published var groupedPhotos: [Date: [Photo]] = [:]
    @Published var currentDate: Date = Date()
    @Published var currentIndex: Int = 0
    
    @Published var showDeleteConfirmation: Bool = false
    @Published var showToast: Bool = false
    @Published var toastMessage: String = ""
    

    // MARK: 최신순 정렬
    var sortedDates: [Date] {
        Photo.sortedDates(from: groupedPhotos)
    }
    
    var currentPhotos: [Photo] {
        groupedPhotos[currentDate] ?? []
    }
    
    var currentPhoto: Photo? {
        guard currentIndex >= 0, currentIndex < currentPhotos.count else { return nil }
        return currentPhotos[currentIndex]
    }
    
    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
    }
    
    func setupModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    func saveCurrentImage() {
        // TODO: ImageFileManager 주석처리된 상태에서는 구현하지 않음 처리해야함
        // guard let currentPhoto = currentPhoto else { return }
        
        showToastMessage("사진이 저장되었습니다")
    }
    
    /// 현재 이미지 삭제
    func deleteCurrentImage() {
        guard let currentPhoto = currentPhoto,
              let context = modelContext else { return }
        
        do {
            // SwiftData에서 삭제
            context.delete(currentPhoto)
            try context.save()
            
            // TODO: ImageFileManager 주석처리된 상태에서는 구현하지 않음
            // try ImageFileManager.shared.deleteFile(fileName: currentPhoto.fileName)
            
            // UI 업데이트
            updateAfterDeletion()
            showToastMessage("사진이 삭제되었습니다.")
            
        } catch {
            showToastMessage("사진 삭제에 실패했습니다.")
        }
    }
    
    /// 삭제 후 UI 업데이트
    private func updateAfterDeletion() {
        // 현재 날짜의 사진 목록 업데이트
        var updatedPhotos = currentPhotos
        if currentIndex < updatedPhotos.count {
            updatedPhotos.remove(at: currentIndex)
        }
        
        if updatedPhotos.isEmpty {
            // 현재 날짜에 더 이상 사진이 없으면 날짜 제거
            groupedPhotos.removeValue(forKey: currentDate)
            
            // 다른 날짜로 이동
            if !sortedDates.isEmpty {
                currentDate = sortedDates.first!
                currentIndex = 0
            }
        } else {
            // 현재 날짜 사진 목록 업데이트
            groupedPhotos[currentDate] = updatedPhotos
            
            // 인덱스 조정
            if currentIndex >= updatedPhotos.count {
                currentIndex = max(0, updatedPhotos.count - 1)
            }
        }
    }
    
    /// 현재 사진과 인덱스 업데이트
    func updateCurrentPhotosAndIndex() {
        let photos = groupedPhotos[currentDate] ?? []
        
        if photos.isEmpty {
            // 현재 날짜에 사진이 없으면 가장 최근 날짜로 이동
            if let firstDate = sortedDates.first,
               let firstDatePhotos = groupedPhotos[firstDate], !firstDatePhotos.isEmpty {
                currentDate = firstDate
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
