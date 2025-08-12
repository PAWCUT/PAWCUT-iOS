//
//  ArchiveView.swift
//  PawCut
//
//  Created by taeni on 8/11/25.
//

import SwiftUI
import SwiftData

struct ArchiveView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Photo.createdAt, order: .reverse) private var photos: [Photo]
    
    @State private var groupedPhotos: [Date: [Photo]] = [:]
    @State private var showGrid: Bool = false
    @State private var currentDate: Date = Date()
    @State private var currentIndex: Int = 0
    
    var body: some View {
        VStack(spacing: 0) {
            if photos.isEmpty {
                EmptyStateView(petType: PetType.cat)
            } else {
                contentView
            }
        }
        .navigationTitle("아카이브")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(.grayScale06, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showGrid.toggle()
                    }
                }) {
                    Image(systemName: showGrid ? "calendar" : "square.grid.2x2")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.grayScale01)
                }
            }
        }
        .task {
            groupedPhotos = groupPhotosByDay(photos: photos)
        }
        .onChange(of: photos) { _, newPhotos in
            groupedPhotos = groupPhotosByDay(photos: newPhotos)
        }
    }
    
    // MARK: - Content View
    private var contentView: some View {
        ZStack {
            Color.grayScale06
                .ignoresSafeArea()
            
            Group {
                if showGrid {
                    PhotoGridView(
                        groupedPhotos: $groupedPhotos,
                        currentDate: $currentDate,
                        currentIndex: $currentIndex
                    )
                } else {
                    PhotoCalendarView(
                        groupedPhotos: $groupedPhotos,
                        currentDate: $currentDate,
                        currentIndex: $currentIndex
                    )
                }
            }
            .transition(.opacity.combined(with: .scale(scale: 0.95)))
        }
    }
    
    // MARK: - Helper Functions
    private func groupPhotosByDay(photos: [Photo]) -> [Date: [Photo]] {
        let calendar = Calendar.current
        return Dictionary(grouping: photos) { photo in
            calendar.startOfDay(for: photo.createdAt)
        }
    }
}

// MARK: - PhotoGridView
struct PhotoGridView: View {
    @Binding var groupedPhotos: [Date: [Photo]]
    @Binding var currentDate: Date
    @Binding var currentIndex: Int
    
    private let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(sortedDates, id: \.self) { date in
                    if let photosForDate = groupedPhotos[date] {
                        ForEach(Array(photosForDate.enumerated()), id: \.element.id) { index, photo in
                            NavigationLink {
                                PhotoDetailsView(
                                    groupedPhotos: $groupedPhotos,
                                    currentDate: .constant(date),
                                    currentIndex: .constant(index)
                                )
                            } label: {
                                PhotoThumbnailView(photo: photo)
                                    .aspectRatio(1, contentMode: .fit)
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                            }
                        }
                    }
                }
            }
            .padding(2)
        }
    }
    
    private var sortedDates: [Date] {
        groupedPhotos.keys.sorted { $0 > $1 }
    }
}

// MARK: - PhotoCalendarView
struct PhotoCalendarView: View {
    @Binding var groupedPhotos: [Date: [Photo]]
    @Binding var currentDate: Date
    @Binding var currentIndex: Int
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일 EEEE"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                ForEach(sortedDates, id: \.self) { date in
                    if let photosForDate = groupedPhotos[date] {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                PawBodyLabel.semi16(
                                    dateFormatter.string(from: date),
                                    color: .grayScale01
                                )
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            
                            PhotoDayGridView(
                                photos: photosForDate,
                                selectedDate: date,
                                groupedPhotos: $groupedPhotos,
                                currentDate: $currentDate,
                                currentIndex: $currentIndex
                            )
                        }
                    }
                }
            }
            .padding(.vertical, 20)
        }
    }
    
    private var sortedDates: [Date] {
        groupedPhotos.keys.sorted { $0 > $1 }
    }
}

// MARK: - PhotoDayGridView
struct PhotoDayGridView: View {
    let photos: [Photo]
    let selectedDate: Date
    @Binding var groupedPhotos: [Date: [Photo]]
    @Binding var currentDate: Date
    @Binding var currentIndex: Int
    
    private let columns = [
        GridItem(.flexible(), spacing: 4),
        GridItem(.flexible(), spacing: 4)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 4) {
            ForEach(Array(photos.enumerated()), id: \.element.id) { index, photo in
                NavigationLink {
                    PhotoDetailsView(
                        groupedPhotos: $groupedPhotos,
                        currentDate: .constant(selectedDate),
                        currentIndex: .constant(index)
                    )
                } label: {
                    PhotoThumbnailView(photo: photo)
                        .aspectRatio(4/3, contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - PhotoThumbnailView
struct PhotoThumbnailView: View {
    let photo: Photo
    @State private var image: UIImage?
    @State private var isLoading = true
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else if isLoading {
                Rectangle()
                    .fill(.grayScale05)
                    .overlay {
                        ProgressView()
                            .tint(.grayScale03)
                            .scaleEffect(0.8)
                    }
            } else {
                Rectangle()
                    .fill(.grayScale05)
                    .overlay {
                        Image(systemName: "photo")
                            .foregroundColor(.grayScale03)
                    }
            }
        }
        .task {
            await loadImage()
        }
    }
    
    private func loadImage() async {
        isLoading = true
        
        // Mock image loading for preview
        let systemImages = ["photo", "camera", "heart.fill", "star.fill", "leaf.fill", "pawprint.fill"]
        let randomImage = systemImages.randomElement() ?? "photo"
        
        // Simulate loading delay
        try? await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
        
        let config = UIImage.SymbolConfiguration(pointSize: 100, weight: .light)
        let mockImage = UIImage(systemName: randomImage, withConfiguration: config)?
            .withTintColor(.systemGray4, renderingMode: .alwaysOriginal)
        
        await MainActor.run {
            self.image = mockImage
            self.isLoading = false
        }
    }
}



// MARK: - PhotoImageView
struct PhotoImageView: View {
    let photo: Photo
    @State private var image: UIImage?
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                Rectangle()
                    .fill(.clear)
                    .overlay {
                        ProgressView()
                            .tint(.white)
                    }
            }
        }
        .task {
            await loadImage()
        }
    }
    
    private func loadImage() async {
        // Mock image loading for preview
        let systemImages = ["photo", "camera", "heart.fill", "star.fill", "leaf.fill", "pawprint.fill"]
        let randomImage = systemImages.randomElement() ?? "photo"
        
        // Simulate loading delay
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        let config = UIImage.SymbolConfiguration(pointSize: 200, weight: .light)
        let mockImage = UIImage(systemName: randomImage, withConfiguration: config)?
            .withTintColor(.systemGray3, renderingMode: .alwaysOriginal)
        
        await MainActor.run {
            self.image = mockImage
        }
    }
}

// MARK: - Mock Data Extension
extension Photo {
    static var mockPhotos: [Photo] {
        let calendar = Calendar.current
        var photos: [Photo] = []
        
        // Create photos for today
        let today = Date()
        for i in 0..<6 {
            let photo = Photo(fileName: "today_photo_\(i).jpg")
            photo.createdAt = calendar.date(byAdding: .minute, value: i * 45, to: today) ?? today
            photos.append(photo)
        }
        
        // Create photos for yesterday
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today) ?? today
        for i in 0..<4 {
            let photo = Photo(fileName: "yesterday_photo_\(i).jpg")
            photo.createdAt = calendar.date(byAdding: .hour, value: i * 2, to: yesterday) ?? yesterday
            photos.append(photo)
        }
        
        // Create photos for 3 days ago
        let threeDaysAgo = calendar.date(byAdding: .day, value: -3, to: today) ?? today
        for i in 0..<5 {
            let photo = Photo(fileName: "threeDaysAgo_photo_\(i).jpg")
            photo.createdAt = calendar.date(byAdding: .hour, value: i * 3, to: threeDaysAgo) ?? threeDaysAgo
            photos.append(photo)
        }
        
        return photos
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        ArchiveView()
            .modelContainer(for: Photo.self)
    }
}
