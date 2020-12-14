//
//  AccFavoritesResp.swift
//  someAPIMadness
//
//  Created by Nizelan on 03.12.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import Foundation
import CoreGraphics

struct AccFavoritesResp: Codable {
    let data: [FavoritePost]
}

struct FavoritePost: Codable {
    let currentId: String
    let title: String?
    let points: Int
    let link: String
    let images: [Images]
    let coverWidth: Int
    let coverHeight: Int

    enum CodingKeys: String, CodingKey {
        case currentId = "id"
        case title
        case points
        case link
        case images
        case coverWidth = "cover_width"
        case coverHeight = "cover_height"
    }
}

struct Images: Codable {
    let imageId: String
    let mp4: String?

    enum CodingKeys: String, CodingKey {
        case imageId = "id"
        case mp4
    }
}

extension FavoritePost {
    var coverSize: CGSize {
        return CGSize(width: coverWidth ?? 0, height: coverHeight ?? 0)
    }

    var aspectRatio: CGFloat {
        return CGFloat(coverWidth ?? 1) / CGFloat(coverHeight ?? 1)
    }
}
