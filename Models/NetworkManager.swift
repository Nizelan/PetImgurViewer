//
//  NetworkManager.swift
//  someAPIMadness
//
//  Created by Nizelan on 16.07.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import Foundation

struct NetworkManadger {
    
    //Fetch data
    
    func fetchGallery() {
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
               do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    self.parseJSON(withData: data)
               } catch {
                    print(error)
               }
           }
        }.resume()
    }
    
    //Parse JSON
    
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
