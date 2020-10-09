//
//  CommentParseModel.swift
//  someAPIMadness
//
//  Created by Nizelan on 09.10.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import Foundation

struct GalleryCommentResponse: Codable {
    let data: [CommentInfo]
}

struct CommentInfo: Codable {
    let comment: String
    let author: String
    let children: [CommentInfo]
}
