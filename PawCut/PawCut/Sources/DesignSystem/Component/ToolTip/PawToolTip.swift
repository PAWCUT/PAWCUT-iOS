//
//  PawToolTip.swift
//  PawCut
//
//  Created by 광로 on 8/12/25.
//

import SwiftUI

struct PawToolTip: View {
    let message: String
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                PawTriangle()
                    .fill(Color(ColorSet.PointPurple.pointPurple01.rawValue))
                    .rotationEffect(.degrees(0))
                    .frame(width: 16, height: 8)
                Spacer()
                    .frame(width: 180)
            }
            Text(message)
                .pretendardFont(size: ._14, weight: .semibold)
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(ColorSet.PointPurple.pointPurple01.rawValue))
                )
        }
    }
}

// MARK: - 툴팁 꼬리 삼각형
struct PawTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 40) {
        PawToolTip(message: "소리를 설정에서 변경할 수 있어요!")
    }
    .padding(40)
}
