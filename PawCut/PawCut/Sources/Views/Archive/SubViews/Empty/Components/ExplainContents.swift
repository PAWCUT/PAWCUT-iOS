//
//  ExplainContents.swift
//  PawCut
//
//  Created by taeni on 9/22/25.
//

import SwiftUI

struct ExplainContents: View {
    let stateString: String
    let explainString: String
    
    var body: some View {
        VStack(spacing: 12) {
            PawTitleLabel.semi18(stateString, color: .grayScale01)
            
            PawBodyLabel.med14(
                explainString,
                color: .grayScale03,
                alignment: .center,
                lineLimit: 2
            )
        }
    }
}

#Preview {
    ExplainContents(stateString: "비어있음", explainString: "아직 찍은 사진이 없습니다.\n오늘의 하루를 남겨보세요.")
}
