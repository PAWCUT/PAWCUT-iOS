//
//  PhotoDetailsView.swift
//  PawCut
//
//  Created by taeni on 8/17/25.
//

import SwiftUI

struct PhotoDetailsView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = PhotoDetailsViewModel()
    // TODO: ViewModel로 분리할 것
    @StateObject private var navigationManager = NavigationManager.shared
    
    // MARK: - Bindings
    @Binding var groupedPhotos: [Date: [Photo]]
    @Binding var currentDate: Date
    @Binding var currentIndex: Int
    
    init(
        groupedPhotos: Binding<[Date: [Photo]]>,
        currentDate: Binding<Date>,
        currentIndex: Binding<Int>
    ) {
        self._groupedPhotos = groupedPhotos
        self._currentDate = currentDate
        self._currentIndex = currentIndex
    }
    
    var body: some View {
        ZStack {
            Color.grayScale06.ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                    .padding(.top, 11)
                    .padding(.horizontal)
                    .padding(.bottom, 26)
                
                imageSliderView
                    .padding(.bottom, 20)
                
                thumbnailStripView
                    .padding(.bottom, 58)
                
                bottomControlsView
                    .padding(.horizontal, 45)
                    .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            setupViewModel()
        }
        .onChange(of: groupedPhotos) { _, _ in
            syncWithViewModel()
        }
        .onChange(of: currentDate) { _, _ in
            syncWithViewModel()
        }
        .onChange(of: currentIndex) { _, _ in
            syncWithViewModel()
        }
        // ViewModel의 변경사항을 Binding에 동기화
        .onChange(of: viewModel.currentDate) { _, newValue in
            currentDate = newValue
        }
        .onChange(of: viewModel.currentIndex) { _, newValue in
            currentIndex = newValue
        }
        .toast(isShowing: $viewModel.showToast, message: viewModel.toastMessage, iconName: "toast_icon", duration: 2.0)
        .pawAlert(
            isShowing: $viewModel.showDeleteConfirmation,
            title: "정말 사진을 삭제할까요?",
            message: "삭제한 사진은 다시 확인할 수 없어요.",
            confirmTitle: "삭제하기",
            cancelTitle: "아니요",
            onConfirm: {
                viewModel.deleteCurrentImage()
            }
        )
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                navigationManager.pop()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.grayScale01)
            }
            Spacer()
        }
        .overlay(
            VStack {
                if let photo = viewModel.currentPhoto {
                    PawTitleLabel.semi16(
                        photo.createdAt.koreanMonthDateString,
                        color: .grayScale01
                    )
                }
            }
        )
        
    }
    
    private var imageSliderView: some View {
        TabView(selection: $viewModel.currentIndex) {
            ForEach(viewModel.currentPhotos.indices, id: \.self) { index in
                AsyncPhotoImageView.fillWidth(
                    fileName: viewModel.currentPhotos[index].fileName,
                    isZoomEnabled: true
                )
                // TODO: 현제 템플릿으로 가로를 채우면 화면이 깨짐
                .aspectRatio(contentMode: .fit)
                .tag(index)
                // Instagram 스타일 전환 효과
                .transition(.scale(scale: 0.9).combined(with: .opacity))
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .frame(maxWidth: .infinity)
        .sideTapNavigationGesture(
            onTapLeft: {
                moveToPreviousImage()
            },
            onTapRight: {
                moveToNextImage()
            },
            edgeRatio: 0.15
        )
    }
    
    private var thumbnailStripView: some View {
        ThumbnailStripView(
            viewModel: viewModel
        )
        .frame(height: 24)
    }
    
    private var bottomControlsView: some View {
        HStack {
            Button(action: {
                viewModel.saveCurrentImage()
            }) {
                ImageComponent(imageName: "download_icon", size: CGSize(width: 20, height: 24))
                    .background(
                        Circle()
                            .fill(Color.grayBackground)
                            .frame(width: 45, height: 45)
                    )
            }
            
            Spacer()
            
            Button(action: {
                viewModel.showDeleteConfirmation = true
            }) {
                ImageComponent(imageName: "trash_icon", size: CGSize(width: 20, height: 23))
                    .background(
                        Circle()
                            .fill(Color.grayBackground)
                            .frame(width: 45, height: 45)
                    )
            }
        }
    }
    
    /// 이전 이미지로 이동
    private func moveToPreviousImage() {
        withAnimation(.easeInOut(duration: 0.3)) {
            if viewModel.currentIndex > 0 {
                viewModel.currentIndex -= 1
            } else {
                // 현재 날짜의 첫 번째 이미지인 경우, 이전 날짜의 마지막 이미지로 이동
                moveToPreviousDate()
            }
        }
    }
    
    /// 다음 이미지로 이동
    private func moveToNextImage() {
        withAnimation(.easeInOut(duration: 0.3)) {
            if viewModel.currentIndex < viewModel.currentPhotos.count - 1 {
                viewModel.currentIndex += 1
            } else {
                // 현재 날짜의 마지막 이미지인 경우, 다음 날짜의 첫 번째 이미지로 이동
                moveToNextDate()
            }
        }
    }
    
    /// 이전 날짜로 이동
    private func moveToPreviousDate() {
        let sortedDates = viewModel.sortedDates
        if let currentDateIndex = sortedDates.firstIndex(of: viewModel.currentDate),
           currentDateIndex < sortedDates.count - 1 {
            let previousDate = sortedDates[currentDateIndex + 1] // 최신순이므로 +1이 이전 날짜
            if let previousDatePhotos = viewModel.groupedPhotos[previousDate], !previousDatePhotos.isEmpty {
                viewModel.currentDate = previousDate
                viewModel.currentIndex = previousDatePhotos.count - 1 // 마지막 이미지로 이동
            }
        }
    }
    
    /// 다음 날짜로 이동
    private func moveToNextDate() {
        let sortedDates = viewModel.sortedDates
        if let currentDateIndex = sortedDates.firstIndex(of: viewModel.currentDate),
           currentDateIndex > 0 {
            let nextDate = sortedDates[currentDateIndex - 1] // 최신순이므로 -1이 다음 날짜
            if let nextDatePhotos = viewModel.groupedPhotos[nextDate], !nextDatePhotos.isEmpty {
                viewModel.currentDate = nextDate
                viewModel.currentIndex = 0 // 첫 번째 이미지로 이동
            }
        }
    }
    
    private func setupViewModel() {
        viewModel.setupModelContext(modelContext)
        syncWithViewModel()
    }
    
    private func syncWithViewModel() {
        viewModel.groupedPhotos = groupedPhotos
        viewModel.currentDate = currentDate
        viewModel.currentIndex = currentIndex
        viewModel.updateCurrentPhotosAndIndex()
    }
}

// MARK: - Thumbnail Strip View
struct ThumbnailStripView: View {
    @ObservedObject var viewModel: PhotoDetailsViewModel
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 3) {
                    ForEach(viewModel.currentPhotos, id: \.id) { photo in
                        thumbnailCell(for: photo, proxy: proxy)
                    }
                }
                // TODO: 현재 인덱스를 가운데로 둘 것인지?
                // TODO: 사용자 제스쳐로 이동되면 currentIndex를 바꾸도록 작업해야함
                //                .padding(.horizontal, UIScreen.main.bounds.width / 2 - 6)
                .frame(minWidth: UIScreen.main.bounds.width)
            }
            .onAppear {
                // 초기 로딩 시 현재 인덱스를 센터로 이동
                scrollToCurrentIndex(proxy: proxy)
            }
            .onChange(of: viewModel.currentIndex) { _, _ in
                // 인덱스 변경 시 센터로 이동
                scrollToCurrentIndex(proxy: proxy)
            }
            .onChange(of: viewModel.currentDate) { _, _ in
                // 날짜 변경 시에도 센터로 이동
                scrollToCurrentIndex(proxy: proxy)
            }
        }
    }
    
    private func thumbnailCell(for photo: Photo, proxy: ScrollViewProxy) -> some View {
        let isSelected = viewModel.currentPhotos.indices.contains(viewModel.currentIndex) &&
        viewModel.currentPhotos[viewModel.currentIndex].id == photo.id
        
        return AsyncPhotoImageView.thumbnail(fileName: photo.fileName)
            .frame(width: isSelected ? 32 : 22, height: 32)
            .aspectRatio(contentMode: .fill)
            .clipped()
            .onTapGesture {
                if let index = viewModel.currentPhotos.firstIndex(where: { $0.id == photo.id }) {
                    viewModel.currentIndex = index
                    // 탭 시에도 센터로 이동
                    scrollToCurrentIndex(proxy: proxy)
                }
            }
            .id(photo.id)
    }
    
    private func scrollToCurrentIndex(proxy: ScrollViewProxy) {
        guard viewModel.currentIndex < viewModel.currentPhotos.count else { return }
        
        let currentPhoto = viewModel.currentPhotos[viewModel.currentIndex]
        
        withAnimation(.easeInOut(duration: 0.3)) {
            proxy.scrollTo(currentPhoto.id, anchor: .center)
        }
    }
}

#Preview {
    @Previewable @State var groupedPhotos = Photo.mockGroupedPhotos
    @Previewable @State var currentDate = Date()
    @Previewable @State var currentIndex = 0
    
    NavigationStack {
        PhotoDetailsView(
            groupedPhotos: $groupedPhotos,
            currentDate: $currentDate,
            currentIndex: $currentIndex
        )
    }
}

