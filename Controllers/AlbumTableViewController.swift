//
//  AlbumTableViewController.swift
//  someAPIMadness
//
//  Created by Nizelan on 27.07.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit

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
        
        if let imageLink = album?.images?[indexPath.row].link {
            cell.imageViewOutlet.image = fetchImage(urlString: imageLink)
        }
        if let downsIs = album?.images?[indexPath.row].downs {
            cell.downsLabel.text = String(downsIs)
        }
        if let upsIs = album?.images?[indexPath.row].ups {
            cell.downsLabel.text = String(upsIs)
        }
        if let titleIs = album?.images?[indexPath.row].title {
            cell.downsLabel.text = titleIs
        }
        
        
        return cell
    }
}
