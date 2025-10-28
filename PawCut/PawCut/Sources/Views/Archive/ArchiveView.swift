//
//  ArchiveView.swift
//  PawCut
//
//  Created by taeni on 8/11/25.
//

import SwiftUI
import SwiftData

struct ArchiveView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = ArchiveViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.groupedPhotos.isEmpty {
                ArchiveEmptyView(petType: viewModel.getPetType()) {
                    viewModel.didTapTakeCutButton()
                }
            } else {
                if viewModel.showGrid {
                    ArchiveGridView(
                        sortedDates: viewModel.sortedDates,
                        groupedPhotos: viewModel.groupedPhotos,
                        onPhotoTap: viewModel.didTapPhotoDetails
                    )
                } else {
                    ArchiveCalendarView(
                        calendarRange: viewModel.calendarRange,
                        thumbnailImages: viewModel.createThumbnailImages(),
                        onDateNavigate: { date in
                            if viewModel.createThumbnailImages().keys.contains(date) {
                                viewModel.didTapPhotoDetails(date: date, index: 0)
                            }
                        }
                    )
                }
            }
        }
        .pawNavigationBar()
        .pawNavigationTitle("아카이브")
        .pawNavigationStyle(.inline)
        .enableNativeSwipeBack()
        .pawNavigationTrailingItems(
            NavigationIconItem(
                imageName: viewModel.showGrid ? "calendar_icon" : "grid_icon",
                action: viewModel.didTapToggleDisplay
            )
        )
        .refreshable {
            viewModel.didTapRefresh()
        }
        .onAppear {
            viewModel.willSetupModelContext(modelContext)
        }
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    
    return NavigationStack(path: $path) {
        VStack {
            Button("Go to Archive") {
                path.append("archive")
            }
        }
        .navigationTitle("")
        .navigationDestination(for: String.self) { _ in
            ArchiveView()
                .modelContainer(for: Photo.self)
        }
        .onAppear {
            path.append("archive")
        }
    }
}
