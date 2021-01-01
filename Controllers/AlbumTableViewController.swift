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

    var album: Post?
    let networkManager = NetworkManager()
    var id: String?
    var name: String?
    var link = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 400
        id = album!.postId
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
        guard let album = album,
            let cell = tableView.dequeueReusableCell(withIdentifier: "SecondCell", for: indexPath) as? AlbumCell else {
                return UITableViewCell()
        }
        if album.images?[indexPath.row].link != nil {
            if album.images![indexPath.row].link.contains("mp4") {
                cell.imageViewOutlet.image = UIImage(named: "playVideo")
                cell.activityIndicator.stopAnimating()
                cell.activityIndicator.isHidden = true
            } else {
                cell.imageViewOutlet.loadImage(from: album.images![indexPath.row].link, completion: { (success) in
                    if success {
                        cell.activityIndicator.stopAnimating()
                        cell.activityIndicator.isHidden = true
                        print("successfully loaded image with url: \(album.images![indexPath.row].link)")
                    } else {
                        cell.activityIndicator.stopAnimating()
                        cell.activityIndicator.isHidden = true
                        print("failed to load image with url: \(album.images![indexPath.row].link)")
                    }
                })
            }
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if album!.images![indexPath.row].link.contains("mp4") {
            let url = album!.images![indexPath.row].link
            let title = album!.title
            link = url
            name = title
            performSegue(withIdentifier: "ShowVideo", sender: Any?.self)
        }
    }

    @IBAction func goToComments(_ sender: UIButton) {
        performSegue(withIdentifier: "CommentsSegue", sender: Any?.self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CommentsSegue" {
            guard let destination = segue.destination as? CommentsViewController else { return }
            destination.albumID = id
        } else if segue.identifier == "ShowVideo" {
            guard let destination = segue.destination as? VideoViewController else { return }
            destination.name = name
            destination.link = link
        }
    }
}
