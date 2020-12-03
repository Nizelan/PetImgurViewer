//
//  AccGalleryResp.swift
//  someAPIMadness
//
//  Created by Nizelan on 02.12.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import Foundation

struct AccGalleryResp: Codable {
    let data: [AccPost]
}

struct AccPost: Codable {
    let postId: String
    let title: String?
    let link: String?

    enum CodingKeys: String, CodingKey {
        case postId = "id"
        case title
        case link
    }
}
