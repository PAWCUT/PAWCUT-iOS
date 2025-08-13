//
//  ArchiveViewModel.swift
//  PawCut
//
//  Created by taeni on 8/13/25.
//

import Foundation
import SwiftUI

@MainActor
final class ArchiveViewModel: ObservableObject {
    
    @Published private(set) var photos: [Photo] = []
    @Published private(set) var groupedPhotos: [Date: [Photo]] = [:]
    @Published private(set) var isLoading = false
    
    @Published var showGrid = false
    @Published var currentDate: Date = Date()
    @Published var currentIndex: Int = 0
    
    var isEmpty: Bool {
        photos.isEmpty
    }
    
    var sortedDates: [Date] {
        groupedPhotos.keys.sorted(by: <)
    }
    
    init() {
        loadData()
    }
    
    func toggleDisplay() {
        withAnimation(.easeInOut(duration: 0.3)) {
            showGrid.toggle()
        }
    }
    
    func refreshData() {
        loadData()
    }
    
    func selectPhoto(_ photo: Photo, at index: Int, date: Date) {
        currentIndex = index
        currentDate = date
        navigateToPhotoDetail()
    }
    
    func selectCalendarDate(_ date: Date) {
        let normalizedDate = Calendar.current.startOfDay(for: date)
        
        guard groupedPhotos[normalizedDate] != nil else { return }
        
        currentIndex = 0
        currentDate = normalizedDate
        navigateToPhotoDetail()
    }
    
    func createThumbnailImages() -> [Date: String] {
        groupedPhotos.compactMapValues { photos in
            photos.first?.fileName
        }
    }
}

private extension ArchiveViewModel {
    
    func loadData() {
        isLoading = true
        
        // Mock 데이터 로딩 시뮬레이션
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.photos = Photo.mockPhotos
            self.updateGroupedPhotos()
            self.isLoading = false
        }
    }
    
    func updateGroupedPhotos() {
        groupedPhotos = Dictionary(grouping: photos) { photo in
            Calendar.current.startOfDay(for: photo.createdAt)
        }
    }
    
    // TODO: navigation 붙일 곳
    func navigateToPhotoDetail() {
    }
    
    func createGroupedPhotosBinding() -> Binding<[Date: [Photo]]> {
        Binding(
            get: { self.groupedPhotos },
            set: { self.groupedPhotos = $0 }
        )
    }
    
    func createCurrentDateBinding() -> Binding<Date> {
        Binding(
            get: { self.currentDate },
            set: { self.currentDate = $0 }
        )
    }
    
    func createCurrentIndexBinding() -> Binding<Int> {
        Binding(
            get: { self.currentIndex },
            set: { self.currentIndex = $0 }
        )
    }
}

extension ArchiveViewModel {
    // TODO: 실제 데이터 가져올 때 쓸 것
    func loadPhotosFromDatabase() async {
    }
}
