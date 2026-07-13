//
//  InterestsSection.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 10.07.2026.
//

import SwiftUI

struct InterestsSection: View {
    
    @Environment(AppState.self)
    private var appState

    @Binding var profile: UserProfile

    private let columns = [
        GridItem(.adaptive(minimum: 120), spacing: 10)
    ]

    var body: some View {

        VStack(alignment: .leading, spacing: 16) {

            Text("Интересы")
                .font(AppFonts.title)

            LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {

                ForEach(Interests.all, id: \.self) { interest in

                    InterestsChip(
                        title: interest,
                        isSelected: appState.selectedInterests.contains(interest)
                    ) {

                        toggle(interest)

                    }

                }

            }

        }

    }

    private func toggle(_ interest: String) {

        if appState.selectedInterests.contains(interest) {

            appState.selectedInterests.removeAll { $0 == interest }

        } else {

            appState.selectedInterests.append(interest)

        }
        
        profile.interests = appState.selectedInterests

    }

}

#Preview {

    @Previewable @State var profile = UserProfile()

    InterestsSection(profile: $profile)

}
