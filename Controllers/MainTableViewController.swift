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
    var albums = [Porst]()
    var imagesCount = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 300
        
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
        
        cell.activityIndicator.startAnimating()

        if albums[indexPath.row].is_album == true {
            if let imageURLString = albums[indexPath.row].images?[0].link {
                if imageURLString.contains("mp4") {
                    cell.imageViewOutlet.image = UIImage(named: "playVideo")
                    cell.activityIndicator.stopAnimating()
                    cell.activityIndicator.isHidden = true
                } else {
                    cell.imageViewOutlet.loadImage(from: imageURLString, completion: { (success) in
                        if success {
                            print("successfully loaded image with url: \(imageURLString)")
                        } else {
                            print("failed to load image with url: \(imageURLString)")
                        }
                    })
                }
            }
        } else {
            if albums[indexPath.row].link!.contains("mp4") {
                cell.imageViewOutlet.image = UIImage(named: "placeholder")
                cell.activityIndicator.stopAnimating()
                cell.activityIndicator.isHidden = true
            } else {
                if let link = albums[indexPath.row].link {
                    cell.imageViewOutlet.loadImage(from: link, completion: { (success) in
                        if success {
                            print("successfully loaded image with url: \(link)")
                        } else {
                            print("failed to load image with url: \(link)")
                        }
                    })
                }
            }
        }

        if albums[indexPath.row].downs != nil {
            cell.downsLabel.text = String(albums[indexPath.row].downs!)
        } else {
            cell.downsImage.isHidden = true
            cell.downsLabel.isHidden = true
        }

        if albums[indexPath.row].ups != nil {
            cell.upsLabel.text = String(albums[indexPath.row].ups!)
        } else {
            cell.upsLabel.isHidden = true
            cell.upsImage.isHidden = true
        }

        if albums[indexPath.row].title != nil {
            cell.imageNamelable.text = albums[indexPath.row].title
        } else {
            cell.imageNamelable.isHidden = true
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAlbum = albums[indexPath.row]
        
        performSegue(withIdentifier: "openAlbum", sender: selectedAlbum)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "openAlbum" else { return }
        guard let destination = segue.destination as? AlbumTableViewController else { return }
        guard let castedSender = sender as? Porst else { return }
        destination.album = castedSender
    }
    
}
