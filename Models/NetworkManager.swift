//
//  NetworkManager.swift
//  someAPIMadness
//
//  Created by Nizelan on 16.07.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import Foundation
import UIKit

struct NetworkManager {
    
    //Fetch data
   
    func fetchGallery(closure: @escaping (GalleryResponse) -> ()) {
        let urlString = "https://api.imgur.com/3/gallery/top/top/week/17?showViral=true&mature=true&album_previews=true"
        
        let httpHeaders = ["Authorization": "Client-ID 094e934ce523296"]
        
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = httpHeaders
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
           if let response = response {
               print(response)
           }
           
           if let data = data {
            if let gallery: GalleryResponse = self.parseJSON(withData: data) {
                    DispatchQueue.main.async {
                        closure(gallery)
                        //print(gallery.data)
                    }
                }
           }
        }.resume()
    }
    
    //Parse JSON
    
    func parseJSON<T>(withData data: Data) -> T? where T:Codable {
        let decoder = JSONDecoder()
        do {
            let galleryData = try decoder.decode(T.self, from: data)
            return galleryData
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}
