//
//  ArchiveViewModel.swift
//  PawCut
//
//  Created by taeni on 8/13/25.
//

import Foundation
import SwiftUI
import SwiftData

@MainActor
final class ArchiveViewModel: ObservableObject {
    
    @Published private(set) var photos: [Photo] = []
    @Published private(set) var groupedPhotos: [Date: [Photo]] = [:]
    @Published private(set) var isLoading = false
    
    @Published var showGrid = false
    @Published var currentDate: Date = Date()
    @Published var currentIndex: Int = 0
    
    @Published private(set) var calendarRange: (startYear: Int, startMonth: Int, endYear: Int, endMonth: Int) = {
        let calendar = Calendar.current
        let today = Date()
        let year = calendar.component(.year, from: today)
        let month = calendar.component(.month, from: today)
        return (year, month, year, month)
    }()
    
    private let navigationManager = NavigationManager.shared
    private let petStorage: PetStorage = PetStorage()
    private let imageFileManager = ImageFileManager.shared
    private var modelContext: ModelContext?
    
    var isEmpty: Bool {
        photos.isEmpty
    }
    
    var sortedDates: [Date] {
        groupedPhotos.keys.sorted(by: <)
    }
    
    
    func willSetupModelContext(_ context: ModelContext) {
        self.modelContext = context
        loadPhotosFromDatabase()
    }
    
    func didTapToggleDisplay() {
        withAnimation(.easeInOut(duration: 0.3)) {
            showGrid.toggle()
        }
    }
    
    func didTapRefresh() {
        loadPhotosFromDatabase()
    }
    
    func didTapPhotoDetails(date: Date, index: Int) {
        navigateToPhotoDetails(date: date, index: index)
    }
    
    func getPetType() -> PetType {
        return petStorage.getPetType()
    }
    
    func createThumbnailImages() -> [Date: String] {
        return groupedPhotos.compactMapValues { photos in
            photos.first?.fileName
        }
    }
    
    func didTapTakeCutButton() {
        navigateToCamera()
    }
    
    private func updateGroupedPhotos() {
        groupedPhotos = Dictionary(grouping: photos) { photo in
            Calendar.current.startOfDay(for: photo.createdAt)
        }
    }
    
    private func updateCalendarRange() {
        let calendar = Calendar.current
        let today = Date()
        
        let endYear = calendar.component(.year, from: today)
        let endMonth = calendar.component(.month, from: today)
        
        let newRange: (startYear: Int, startMonth: Int, endYear: Int, endMonth: Int)
        
        // 이미지가 없다면 현재 달만 표시
        if sortedDates.isEmpty {
            newRange = (endYear, endMonth, endYear, endMonth)
        } else {
            // 이미지가 있다면 제일 오래된 이미지부터 현재 달까지
            let oldestDate = sortedDates.first! // 이미지가 하나라도 있는지 검사
            let startYear = calendar.component(.year, from: oldestDate)
            let startMonth = calendar.component(.month, from: oldestDate)
            newRange = (startYear, startMonth, endYear, endMonth)
        }
        
        // 범위가 변경된 경우에만 업데이트
        if calendarRange.startYear != newRange.startYear ||
            calendarRange.startMonth != newRange.startMonth ||
            calendarRange.endYear != newRange.endYear ||
            calendarRange.endMonth != newRange.endMonth {
            calendarRange = newRange
        }
    }
}


private extension ArchiveViewModel {
    func navigateToPhotoDetails(date: Date, index: Int) {
        navigationManager.navigate(to: .main(.photoDetails(date: date, index: index)))
    }
    
    func navigateToCamera(){
        navigationManager.navigate(to: .main(.camera))
    }
}

// TODO: SwiftData 처리를 extension 으로 해둠. 추후 처리 필요
private extension ArchiveViewModel {
    
    func loadPhotosFromDatabase() {
        guard let modelContext = modelContext else { return }
        
        isLoading = true
        
        Task {
            do {
                let descriptor = FetchDescriptor<Photo>(
                    sortBy: [SortDescriptor(\.createdAt, order: .forward)]
                )
                let fetchedPhotos = try modelContext.fetch(descriptor)
                
                await MainActor.run {
                    self.photos = fetchedPhotos
                    self.updateGroupedPhotos()
                    self.updateCalendarRange()
                    self.isLoading = false
                }
                
            } catch {
                await MainActor.run {
                    print("사진 로딩 실패: \(error)")
                    self.isLoading = false
                }
            }
        }
    }
}
