//
//  PawBackButtonNavigationBar.swift
//  PawCut
//
//  Created by Luminouxx on 8/18/25.
//

import SwiftUI

struct PawBackButtonNavigationBar: View {
    let backAction: () -> Void
    
    var body: some View {
        HStack {
            Button(action: backAction) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.grayScale01)
            }
            .frame(width: 33, height: 44)
            
            Spacer()
        }
    }
}


#Preview {
    PawBackButtonNavigationBar {
        
    }
}
