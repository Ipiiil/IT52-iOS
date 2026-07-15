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
                        isSelected: profile.interestedCategoryIDs.contains(
                            Interests.id(for: interest) ?? -1
                        )
                    ) {

                        toggle(interest)

                    }

                }

            }

        }

    }

    private func toggle(_ interest: String) {

        guard let id = Interests.id(for: interest) else {
            return
        }

        if profile.interestedCategoryIDs.contains(id) {

            profile.interestedCategoryIDs.removeAll { $0 == id }

        } else {

            profile.interestedCategoryIDs.append(id)

        }
    }

}

#Preview {

    @Previewable @State var profile = UserProfile()

    InterestsSection(profile: $profile)

}
