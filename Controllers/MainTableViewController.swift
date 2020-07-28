//
//  TableViewController.swift
//  someAPIMadness
//
//  Created by Nizelan on 14.07.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    
    private let networkManager = NetworkManadger()
    var albums = [GalleryEntry]()
    var indexPathRow = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 200
        
        self.networkManager.fetchGallery { (galleryArray: GalleryResponse) in
            
            self.albums = galleryArray.data
            print(self.albums)
            self.tableView.reloadData()
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return albums.count
    }
    
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AlbumCell
        
        var imageURL: URL?
        var image: UIImage? {
            get {
                cell.imageViewOutlet.image
            }
            set {
                cell.activityIndicator.stopAnimating()
                cell.activityIndicator.isHidden = true
                cell.imageViewOutlet.image = newValue
                cell.imageViewOutlet.sizeToFit()
            }
        }
        func fetchImage(urlString: String) -> UIImage? {
            imageURL = URL(string: urlString)
            cell.activityIndicator.isHidden = false
            cell.activityIndicator.startAnimating()
            guard let url = imageURL, let imageData = try? Data(contentsOf: url) else { return UIImage(named: "placeholder") }
            image = UIImage(data: imageData)
            return image
        }
        
        if albums[indexPath.row].is_album == true {
            if let imageURLString = albums[indexPath.row].images?[0].link {
                cell.imageViewOutlet.image = fetchImage(urlString: imageURLString)
            }
        } else {
            cell.imageViewOutlet.image = fetchImage(urlString: albums[indexPath.row].link!)
        }
        
        
        
        
        
        
        
//         if let albumCell = cell as? AlbumCell {
//             albumCell.imageViewOutlet.image = fetchImage(urlString: albums[indexPath.row].link!)
//         }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAlbum = albums[indexPath.row]
        
        for i in 0..<albums.count {
            print("isAlbum____________________\(albums[indexPath.row].is_album)")
            print("Images____________________\(albums[indexPath.row].images)")
            print("Link____________________\(albums[indexPath.row].link)")
        }
        
        performSegue(withIdentifier: "openAlbum", sender: selectedAlbum)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "openAlbum" else { return }
        guard let destination = segue.destination as? AlbumTableViewController else { return }
        guard let castedSender = sender as? GalleryEntry else { return }
        destination.album = castedSender
    }
    
}
