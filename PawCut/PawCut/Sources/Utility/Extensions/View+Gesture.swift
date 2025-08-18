//
//  View+Gesture.swift
//  PawCut
//
//  Created by taeni on 8/17/25.
//

import SwiftUI

extension View {
    
    /// swipe
    /// - Parameters:
    ///   - onSwipeLeft: 왼쪽 스와이프 시 실행할 액션
    ///   - onSwipeRight: 오른쪽 스와이프 시 실행할 액션
    ///   - threshold: 스와이프 감지 임계값 (기본값: 50)
    func swipeGesture(
        onSwipeLeft: @escaping () -> Void = {},
        onSwipeRight: @escaping () -> Void = {},
        threshold: CGFloat = 50
    ) -> some View {
        self.gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width > threshold {
                        onSwipeRight()
                    } else if value.translation.width < -threshold {
                        onSwipeLeft()
                    }
                }
        )
    }
    
    /// 하단 slider gesture
    /// - Parameters:
    ///   - dragOffset: 드래그 오프셋 바인딩
    ///   - isDragging: 드래그 상태 바인딩
    ///   - onDragChanged: 드래그 중 호출되는 클로저
    ///   - onDragEnded: 드래그 종료 시 호출되는 클로저
    func photoSlideGesture(
        dragOffset: Binding<CGFloat>,
        isDragging: Binding<Bool>,
        onDragChanged: @escaping (CGFloat) -> Void = { _ in },
        onDragEnded: @escaping (CGFloat) -> Void
    ) -> some View {
        self.gesture(
            DragGesture()
                .onChanged { value in
                    isDragging.wrappedValue = true
                    dragOffset.wrappedValue = value.translation.width
                    onDragChanged(value.translation.width)
                }
                .onEnded { value in
                    isDragging.wrappedValue = false
                    onDragEnded(value.translation.width)
                }
        )
    }
    
    /// Pinch Zoom
    /// - Parameters:
    ///   - scale: 확대/축소 비율 바인딩
    ///   - lastScaleValue: 마지막 스케일 값 바인딩
    ///   - minScale: 최소 확대 비율 (기본값: 1.0)
    ///   - maxScale: 최대 확대 비율 (기본값: 3.0)
    func pinchZoomGesture(
        scale: Binding<CGFloat>,
        lastScaleValue: Binding<CGFloat>,
        minScale: CGFloat = 1.0,
        maxScale: CGFloat = 4.0
    ) -> some View {
        self.gesture(
            MagnificationGesture()
                .onChanged { value in
                    let delta = value / lastScaleValue.wrappedValue
                    lastScaleValue.wrappedValue = value
                    scale.wrappedValue *= delta
                }
                .onEnded { _ in
                    lastScaleValue.wrappedValue = 1.0
                    withAnimation {
                        scale.wrappedValue = max(minScale, min(scale.wrappedValue, maxScale))
                    }
                }
        )
    }
    
    /// Double Tab
    /// - Parameters:
    ///   - scale: 확대/축소 비율 바인딩
    ///   - defaultScale: 기본 스케일 (기본값: 1.0)
    ///   - zoomScale: 줌 스케일 (기본값: 2.5)
    func doubleTapZoomGesture(
        scale: Binding<CGFloat>,
        defaultScale: CGFloat = 1.0,
        zoomScale: CGFloat = 2.0
    ) -> some View {
        self.onTapGesture(count: 2) {
            withAnimation {
                if scale.wrappedValue > defaultScale {
                    scale.wrappedValue = defaultScale
                } else {
                    scale.wrappedValue = zoomScale
                }
            }
        }
    }
    
    /// 좌우 끝 영역
    /// - Parameters:
    ///   - onTapLeft: 왼쪽 영역 터치 시 실행할 액션 (이전)
    ///   - onTapRight: 오른쪽 영역 터치 시 실행할 액션 (다음)
    ///   - edgeRatio: 좌우 끝 영역의 비율 (기본값: 0.2 = 20%)
    func sideTapNavigationGesture(
        onTapLeft: @escaping () -> Void = {},
        onTapRight: @escaping () -> Void = {},
        edgeRatio: CGFloat = 0.2
    ) -> some View {
        GeometryReader { geometry in
            ZStack {
                self
                
                // 투명한 터치 영역들
                HStack(spacing: 0) {
                    // 왼쪽 터치 영역 (이전)
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: geometry.size.width * edgeRatio)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            onTapLeft()
                        }
                    
                    // 중앙 영역 (터치 무시)
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: geometry.size.width * (1 - edgeRatio * 2))
                    
                    // 오른쪽 터치 영역 (다음)
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: geometry.size.width * edgeRatio)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            onTapRight()
                        }
                }
            }
        }
    }
}
