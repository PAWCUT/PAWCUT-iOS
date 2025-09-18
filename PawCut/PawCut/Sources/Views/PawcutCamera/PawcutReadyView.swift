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

            // TODO: 스택을 쓸 경우, 생각을 많이 해보자, 컴포넌트 SubView로 분리
            VStack(spacing: 0) {
                Spacer()

                // TODO: PawLabel 컴포넌트로 변경
                VStack(spacing: 28) {
                    Image("onboarding_1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 190, height: 217)
                    
                    // TODO: PawLabel 컴포넌트로 변경
                    Text("촬영이 바로 시작됩니다\n준비해 주세요!")
                        .pretendardFont(size: ._20, weight: .semibold)
                        .foregroundColor(.grayScale01)
                        .multilineTextAlignment(.center)
                }

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
