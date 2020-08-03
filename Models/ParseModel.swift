//
//  File.swift
//  someAPIMadness
//
//  Created by Nizelan on 16.07.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import Foundation

struct GalleryResponse: Codable {
    let data: [Post]
}

struct Post: Codable {
    let ups: Int?
    let downs: Int?
    let title: String?
    let is_album: Bool
    let link: String?
    let images: [Image]?
}

struct Image: Codable {
    let link: String
}
