//
//  UserProfileView.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 09.07.2026.
//
import SwiftUI
import PhotosUI

struct UserProfileView: View {
    
    @Environment(AppState.self)
    private var appState

    @State private var profile = UserProfile()
    @State private var isLoading = false
    @State private var isSaving = false
    @State private var errorMessage: String?

    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedPhotoData: Data?

    @Environment(AuthViewModel.self)
    private var authViewModel

    private let profileService = ProfileService()

    var body: some View {

        List {
            Section {

                ProfileHeaderView(
                    selectedPhotoItem: $selectedPhotoItem,
                    localImageData: selectedPhotoData,
                    avatarURL: profile.avatarURL
                )
                .padding()

                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                } else {
                    PersonalInfoSection(profile: $profile)
                        .padding()

                    BioSection(profile: $profile)
                        .padding()

                    ProfileSettingSection(profile: $profile)
                        .padding()

                    InterestsSection(profile: $profile)
                        .padding()
                }

                if let errorMessage {
                    Text(errorMessage)
                        .font(AppFonts.caption)
                        .foregroundStyle(.red)
                }

                Button {
                    Task { await save() }
                } label: {
                    if isSaving {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("Сохранить")
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(isLoading || isSaving)
            }

            Button("Выйти") {
                authViewModel.logout()
            }
            .foregroundStyle(.red)
        }
        .navigationTitle("Профиль")
        .task {
            await load()
        }
        .onChange(of: selectedPhotoItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {

                    if data.count <= 800 * 1024 {
                        selectedPhotoData = data
                    } else {
                        errorMessage = "Размер фото не должен превышать 800 КБ"
                    }
                }
            }
        }
    }

    private func load() async {
        isLoading = true
        errorMessage = nil
        do {
            profile = try await profileService.fetchProfile()
            
            appState.selectedInterestsIDs = profile.interestedCategoryIDs
            
            appState.selectedInterests = Interests.names(
                for: profile.interestedCategoryIDs
            )
            
        } catch {
            errorMessage = "Не удалось загрузить профиль"
        }
        isLoading = false
    }

    private func save() async {
        isSaving = true
        errorMessage = nil
        do {
            try await profileService.updateProfile(profile, avatarImageData: selectedPhotoData)
            selectedPhotoData = nil
            profile = try await profileService.fetchProfile()
        } catch {
            errorMessage = "Не удалось сохранить изменения"
        }
        isSaving = false
    }
}

#Preview {
    UserProfileView()
        .environment(AuthViewModel())
}
