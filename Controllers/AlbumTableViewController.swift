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
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("_________________________")
        print(album)
        print("_________________________")
        self.tableView.reloadData()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AlbumCell

        var imageURL: URL?
        var image: UIImage? {
            get {
                cell.imageViewOutlet.image
            }
            set {
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
        
        //cell.imageViewOutlet.image = fetchImage(urlString: album[indexPathRow].images![indexPath.row].link)
        
        
        return cell
    }
}
