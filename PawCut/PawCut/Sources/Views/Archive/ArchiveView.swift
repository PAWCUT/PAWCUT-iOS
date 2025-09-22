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
            // TODO: VM bye
            if viewModel.groupedPhotos.isEmpty {
                ArchiveEmptyView(petType: viewModel.getPetType())
            } else {
                if viewModel.showGrid {
                    ArchiveGridView(viewModel: viewModel)
                } else {
                    ArchiveCalendarView(viewModel: viewModel)
                }
            }
        }
        .navigationTitle("아카이브")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .toolbarBackground(.grayScale06, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.toggleDisplay()
                }) {
                    ImageComponent(
                        imageName: viewModel.showGrid ? "calendar_icon" : "grid_icon",
                        size: CGSize(width: 20, height: 20)
                    )
                }
            }
        }
        .refreshable {
            viewModel.refreshData()
        }
        .onAppear {
            viewModel.setupModelContext(modelContext)
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
