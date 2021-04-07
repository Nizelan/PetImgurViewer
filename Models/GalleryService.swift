//
//  NetworkMediator.swift
//  someAPIMadness
//
//  Created by Nizelan on 16.03.2021.
//  Copyright © 2021 Nizelan. All rights reserved.
//

import Foundation
import UIKit

class GalleryService {
    let networkManager = NetworkManager()

    var albums = [Post]()
    var page = 1

    func fetchGalleryAlbums(selectedAlbum: SelectedAlbum, closure: @escaping (GalleryResponse) -> Void) {
        switch selectedAlbum {
        case .mostViral:
            networkManager.fetchGallery(sections: "top", sort: "viral", window: "week", page: page) { galleryRasponse in
                DispatchQueue.main.async {
                    closure(galleryRasponse)
                }
            }
        case .following:
            networkManager.fetchGallery(
                sections: SettingsData.sectionsData,
                sort: SettingsData.sortData,
                window: SettingsData.windowData,
                page: page
            ) { galleryRasponse in
                DispatchQueue.main.async {
                    closure(galleryRasponse)
                }
            }
        }
    }
}
