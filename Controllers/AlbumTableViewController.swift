//
//  AlbumTableViewController.swift
//  someAPIMadness
//
//  Created by Nizelan on 27.07.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class AlbumTableViewController: UITableViewController {

    var album: GalleryEntry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 400
        print("_________________________")
        print(album)
        print("_________________________")
        self.tableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("_________________________")
        print(album)
        print("_________________________")
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return album!.images!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SecondCell", for: indexPath) as! AlbumCell
        
        cell.downsImage.isHidden = false
        cell.downsLabel.isHidden = false
        cell.upsLabel.isHidden = false
        cell.upsImage.isHidden = false
        cell.imageNamelable.isHidden = false
        
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
            let queue = DispatchQueue.global(qos: .utility)
            queue.async {
                guard let url = imageURL, let imageData = try? Data(contentsOf: url) else { return }
                DispatchQueue.main.async {
                    image = UIImage(data: imageData)
                }
            }
            return image
        }
        
        if album?.images?[indexPath.row].link != nil {
            if album!.images![indexPath.row].link.contains("mp4") {
                cell.imageViewOutlet.isHidden = true
                cell.activityIndicator.stopAnimating()
                cell.activityIndicator.isHidden = true
                let url = URL(string: album!.images![indexPath.row].link)
                let player = AVPlayer(url: url!)
                let vc = AVPlayerViewController()
                vc.player = player

                present(vc, animated: true) {
                    vc.player?.play()
                }
            } else {
                cell.imageViewOutlet.image = fetchImage(urlString: album!.images![indexPath.row].link)
            }
        }
        if album?.images?[indexPath.row].downs != nil {
            cell.downsLabel.text = String(album!.images![indexPath.row].downs!)
        } else {
            cell.downsImage.isHidden = true
            cell.downsLabel.isHidden = true
        }
        if album?.images?[indexPath.row].ups != nil {
            cell.upsLabel.text = String(album!.images![indexPath.row].ups!)
        } else {
            cell.upsLabel.isHidden = true
            cell.upsImage.isHidden = true
        }
        if album?.images?[indexPath.row].title != nil {
            cell.imageNamelable.text = album?.images?[indexPath.row].title
        } else {
            cell.imageNamelable.isHidden = true
        }
        
        return cell
    }
    
    
}
