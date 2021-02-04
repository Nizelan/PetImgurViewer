//
//  File.swift
//  someAPIMadness
//
//  Created by Nizelan on 16.07.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import Foundation
import CoreGraphics

struct GalleryResponse: Codable {
    let data: [Post]
}

struct Post: Codable {
    let postId: String
    let ups: Int?
    let downs: Int?
    let title: String?
    let isAlbum: Bool
    let link: String?
    let images: [Image]?
    let coverWidth: Int?
    let coverHeight: Int?

    enum CodingKeys: String, CodingKey {
        case postId = "id"
        case ups
        case downs
        case title
        case isAlbum = "is_album"
        case link
        case images
        case coverWidth = "cover_width"
        case coverHeight = "cover_height"
    }
}

struct Image: Codable {
    let link: String
    let width: Int?
    let height: Int?
}

extension Post {

    func coverLink(index: Int) -> String? {
        var coverImageLink: String? {
            if isAlbum {
                return images?[index].link
            } else {
                return link
            }
        }
        return coverImageLink
    }

    var coverSize: CGSize {
        return CGSize(width: coverWidth ?? 0, height: coverHeight ?? 0)
    }

    var aspectRatio: CGFloat {
        if isAlbum {
            guard let image = images?.first else {
                return 1
            }
            return CGFloat(image.width ?? 1) / CGFloat(image.height ?? 1)
        } else {
            return CGFloat(coverWidth ?? 1) / CGFloat(coverHeight ?? 1)
        }
    }
}
