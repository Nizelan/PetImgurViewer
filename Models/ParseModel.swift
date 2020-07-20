//
//  File.swift
//  someAPIMadness
//
//  Created by Nizelan on 16.07.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import Foundation

struct ImgurImage: Codable {
    let data: [Images]
}

struct Images: Codable {
    let link: String
    let titel: String?
}
