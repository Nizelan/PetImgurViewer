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
    let id: String
    let ups: Int?
    let downs: Int?
    let title: String?
    let is_album: Bool
    let link: String?
    let images: [Image]?
    let cover_width: Int?
    let cover_height: Int?
}

struct Image: Codable {
    let link: String
    let width: Int?
    let height: Int?
}


extension Post {
    var coverImageLink: String? {
        if is_album {
            return images?.first?.link
        } else {
            return link
        }
    }

    var coverSize: CGSize {
        return CGSize(width: cover_width ?? 0, height: cover_height ?? 0)
    }

    var aspectRatio: CGFloat {
        if is_album {
            guard let image = images?.first else {
                return 1
            }
            return CGFloat(image.width ?? 1) / CGFloat(image.height ?? 1)
        } else {
            return CGFloat(cover_width ?? 1) / CGFloat(cover_height ?? 1)
        }
    }
}
