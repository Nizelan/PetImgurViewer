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

    var album: Porst?
    let networkManager = NetworkManadger()
    
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
        guard let count = album?.images?.count else { return 0 }
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SecondCell", for: indexPath) as! AlbumCell
        
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
                cell.imageViewOutlet.image = UIImage(named: "playVideo")
                cell.activityIndicator.stopAnimating()
                cell.activityIndicator.isHidden = true
                
            } else {
                cell.imageViewOutlet.image = fetchImage(urlString: album!.images![indexPath.row].link)
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if album!.images![indexPath.row].link.contains("mp4") {
            
            let url = URL(string: album!.images![indexPath.row].link)
            let player = AVPlayer(url: url!)
            let vc = AVPlayerViewController()
            vc.player = player
            
            present(vc, animated: true) {
                vc.player?.play()
            }
        } else {
            return
        }
    }
}
