//
//  BottomRoundedShape .swift
//  PawCut
//
//  Created by Jay on 10/19/25.
//
import SwiftUI

struct BottomRoundedShape: Shape {
    var radius: CGFloat = 18
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY)) // 왼쪽 위
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY)) // 오른쪽 위
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - radius)) // 오른쪽 아래 위
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX - radius, y: rect.maxY),
            control: CGPoint(x: rect.maxX, y: rect.maxY)
        )
        path.addLine(to: CGPoint(x: rect.minX + radius, y: rect.maxY))
        path.addQuadCurve(
            to: CGPoint(x: rect.minX, y: rect.maxY - radius),
            control: CGPoint(x: rect.minX, y: rect.maxY)
        )
        path.closeSubpath()
        return path
    }
}
