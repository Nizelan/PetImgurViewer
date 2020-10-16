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
    var urlString = "https://api.imgur.com/3/gallery/hot/top/week/1?showViral=true&mature=true&album_previews=true"
    //Fetch data
   
    func fetchGallery(sections: String, sort: String, window: String, closure: @escaping (GalleryResponse) -> ()) {
        
        let urlString = "https://api.imgur.com/3/gallery/\(sections)/\(sort)/\(window)/1?showViral=true&mature=true&album_previews=true"
        print(urlString)
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

    func fetchImage(urlString: String, completion: @escaping (UIImage?) -> ()) {
        let imageURL = URL(string: urlString)
        DispatchQueue.global(qos: .utility).async {
            guard let url = imageURL, let imageData = try? Data(contentsOf: url) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            DispatchQueue.main.async {
                completion(UIImage(data: imageData))
            }
        }
    }
    
    func fetchComment(sort: String, id: String, closure: @escaping (GalleryCommentResponse) -> ()) {
        
        let urlString = "https://api.imgur.com/3/gallery/\(id)/comments/\(sort)"
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
                if let comment: GalleryCommentResponse = self.parseJSON(withData: data) {
                    DispatchQueue.main.async {
                        closure(comment)
                    }
                }
            }
        }.resume()
    }

    /// Parse JSON
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
