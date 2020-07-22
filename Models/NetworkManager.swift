//
//  NetworkManager.swift
//  someAPIMadness
//
//  Created by Nizelan on 16.07.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import Foundation

struct NetworkManadger {
    //Authorization
    
    func authorization(url: URL) {
        let httpHeaders = ["Authorization": "Client-ID 094e934ce523296"]
        
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
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    //Fetch data
    
    func fetchGallery() {
        let urlString = "https://api.imgur.com/3/gallery/top/top/week/17?showViral=true&mature=true&album_previews=true"
      
        guard let url = URL(string: urlString) else { return }
       
        authorization(url: url)
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                self.parseJSON(withData: data)
            }
        }
        task.resume()
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
