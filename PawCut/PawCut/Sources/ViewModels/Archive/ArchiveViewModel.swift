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
    
    private let navigationManager = NavigationManager.shared
    private let petStorage: PetStorage = PetStorage()
    private let imageFileManager = ImageFileManager.shared
    private var modelContext: ModelContext?
    
    @Published var showGrid = false
    @Published var currentDate: Date = Date()
    @Published var currentIndex: Int = 0
    
    var isEmpty: Bool {
        photos.isEmpty
    }
    
    var sortedDates: [Date] {
        groupedPhotos.keys.sorted(by: <)
    }
    
    func setupModelContext(_ context: ModelContext) {
        self.modelContext = context
        loadPhotosFromDatabase()
    }
    
    func toggleDisplay() {
        withAnimation(.easeInOut(duration: 0.3)) {
            showGrid.toggle()
        }
    }
    
    func refreshData() {
        loadPhotosFromDatabase()
    }
    
    func goToDetails(date: Date, index: Int) {
        navigateToPhotoDetails(date: date, index: index)
    }
    
    func createThumbnailImages() -> [Date: String] {
        groupedPhotos.compactMapValues { photos in
            photos.first?.fileName
        }
    }
    
    func getPetType() -> PetType {
        petStorage.getPetType()
    }
}

private extension ArchiveViewModel {
    
    func navigateToPhotoDetails(date: Date, index: Int) {
        navigationManager.navigate(to: .main(.photoDetails(date: date, index: index)))
    }
    
    func updateGroupedPhotos() {
        groupedPhotos = Dictionary(grouping: photos) { photo in
            Calendar.current.startOfDay(for: photo.createdAt)
        }
    }
}

// TODO: SwiftData 처리를 extension 으로 해둠. 추후 처리 필요
extension ArchiveViewModel {
    
    func loadPhotosFromDatabase() {
        guard let modelContext = modelContext else { return }
        
        isLoading = true
        
        Task {
            do {
                let descriptor = FetchDescriptor<Photo>(
                    sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
                )
                let fetchedPhotos = try modelContext.fetch(descriptor)
                
                await MainActor.run {
                    self.photos = fetchedPhotos
                    self.updateGroupedPhotos()
                    self.isLoading = false
                }
                
            } catch {
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }
}
