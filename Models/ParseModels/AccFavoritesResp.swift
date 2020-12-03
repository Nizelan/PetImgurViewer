//
//  AccFavoritesResp.swift
//  someAPIMadness
//
//  Created by Nizelan on 03.12.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import Foundation

struct AccFavoritesResp: Codable {
    let data: [FavoritePost]
}

struct FavoritePost: Codable {
    let currentId: String
    let title: String
    let points: Int
    let link: String
    let images: [Images]

    enum CodingKeys: String, CodingKey {
        case currentId = "id"
        case title
        case points
        case link
        case images
    }
}

struct Images: Codable {
    let imageId: String

    enum CodingKeys: String, CodingKey {
        case imageId = "id"
    }
}
