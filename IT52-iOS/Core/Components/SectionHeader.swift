//
//  SectionHeader.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 07.07.2026.
//

import SwiftUI

struct SectionHeader: View {
    
    let title: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil
    
    var body: some View {
        
        HStack {
            
            Text(title)
                .font(AppFonts.headline)
            
            Spacer()
            
            if let actionTitle,
               let action {
                
                Button(actionTitle) {
                    action()
                }
                .font(AppFonts.caption)
            }
        }
    }
}

#Preview {
    
    SectionHeader(title: "Ближайшие события")
}
