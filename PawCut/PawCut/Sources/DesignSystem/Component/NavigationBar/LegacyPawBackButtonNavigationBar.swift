//
//  PawBackButtonNavigationBar.swift
//  PawCut
//
//  Created by Luminouxx on 8/18/25.
//

import SwiftUI

struct LegacyPawBackButtonNavigationBar: View {
    let backAction: () -> Void
    
    var body: some View {
        HStack {
            Button(action: backAction) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.grayScale01)
            }
            .frame(width: 36, height: 44)
            .contentShape(Rectangle())
            
            Spacer()
        }
    }
}


#Preview {
    LegacyPawBackButtonNavigationBar {
        
    }
}
