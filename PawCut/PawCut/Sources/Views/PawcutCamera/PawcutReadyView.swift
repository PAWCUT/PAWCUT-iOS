//
//  PawcutReady.swift
//  PawCut
//
//  Created by 광로 on 7/17/25.
//

import SwiftUI

struct PawcutReadyView: View {
    
    @StateObject private var viewModel = PawcutReadyViewModel()
    
    var body: some View {
        ZStack {
            Color.grayScale06
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                PawcutReadySubView()
                Spacer()
            }
        }
        .onAppear(perform: viewModel.moveToNext)
        .navigationBarHidden(true)
    }
}

#Preview {
    PawcutReadyView()
}
