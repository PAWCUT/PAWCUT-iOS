//
//  PawCutApp.swift
//  PawCut
//
//  Created by Luminouxx on 7/8/25.
//

import SwiftUI

@main
struct PawCutApp: App {
    @State private var showSplash = true
    
    init() {
        FontSet.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .scaleEffect(showSplash ? 0.95 : 1.0)
                    .opacity(showSplash ? 0 : 1)
                
                if showSplash {
                    SplashView()
                        .transition(.asymmetric(
                            insertion: .identity,
                            removal: .opacity.combined(with: .scale(scale: 1.1))
                        ))
                        .zIndex(1)
                }
            }
            .onAppear {
                hideSplash()
            }
            .animation(.easeInOut(duration: 0.8), value: showSplash)
        }
    }
}

extension PawCutApp {
    func hideSplash() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeInOut(duration: 0.8)) {
                showSplash = false
            }
        }
    }
}
