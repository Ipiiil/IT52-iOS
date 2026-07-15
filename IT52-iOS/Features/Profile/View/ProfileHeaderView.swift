//
//  ProfileHeaderView.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 10.07.2026.
//

import SwiftUI
import PhotosUI

struct ProfileHeaderView: View {

    @Binding var selectedPhotoItem: PhotosPickerItem?
    let localImageData: Data?
    let avatarURL: String?

    var body: some View {

        VStack(spacing: 16) {

            avatarImage
                .frame(width: 120, height: 120)
                .clipShape(Circle())

            PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                Text("Изменить фото")
                    .font(AppFonts.caption)
            }
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private var avatarImage: some View {

        if let localImageData, let uiImage = UIImage(data: localImageData) {
            // локально выбранное, ещё не сохранённое фото — показываем сразу, не дожидаясь сервера
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()

        } else if let avatarURL, let url = URL(string: avatarURL) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                default:
                    placeholderAvatar
                }
            }

        } else {
            placeholderAvatar
        }
    }

    private var placeholderAvatar: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .scaledToFit()
            .foregroundStyle(AppColors.accent)
    }
}

#Preview {
    ProfileHeaderView(selectedPhotoItem: .constant(nil), localImageData: nil, avatarURL: nil)
}
