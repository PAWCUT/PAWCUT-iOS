//
//  MainDestination.swift
//  PawCut
//
//  Created by Luminouxx on 8/11/25.
//

import SwiftUI

enum MainDestination: NavigationDestination {
    case home
    
    @ViewBuilder
    func view() -> some View {
        switch self {
        case .home:
            // TODO: HomeView로 수정 예정
            VStack {
                Spacer()
                
                NavigationLink(destination: PawcutCamera()) {
                    Text("카메라 테스트")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                
                Spacer()
            }
        }
    }
}
