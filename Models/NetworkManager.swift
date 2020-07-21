//
//  NetworkManager.swift
//  someAPIMadness
//
//  Created by Nizelan on 16.07.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import Foundation

struct NetworkManadger {
    
    func fetchGallery() {
        let urlString = "https://api.imgur.com/3/gallery/top/top/week/17?showViral=true&mature=true&album_previews=true"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                let dataString = String(data: data, encoding: .utf8)
                print(dataString!)
                self.parseJSON(withData: data)
            }
        }
        task.resume()
    }
    
    func parseJSON(withData data: Data) {
        let decoder = JSONDecoder()
        do {
            let galleryResponse = try decoder.decode(GalleryResponse.self, from: data)
            print(galleryResponse.data[0].link)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
