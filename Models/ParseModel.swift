//
//  File.swift
//  someAPIMadness
//
//  Created by Nizelan on 16.07.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import Foundation

struct GalleryResponse: Codable {
    let data: [GalleryEntry]
}

struct GalleryEntry: Codable {
    let images: [Images]
}

struct Images: Codable {
    let title: String?
    let link: String
    let ups: Int?
    let downs: Int?
}
