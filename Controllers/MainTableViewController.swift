//
//  TableViewController.swift
//  someAPIMadness
//
//  Created by Nizelan on 14.07.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    private let networkManager = NetworkManager()
    var sections = "hot"
    var sort = "top"
    var window = "viral"
    var albums = [Post]()
    var imagesCount = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "AlbumsCell", bundle: nil), forCellReuseIdentifier: "MainAlbumCell")

        self.networkManager.fetchGallery(sections: SettingsData.sectionsData,
                                         sort: SettingsData.sortData,
                                         window: SettingsData.windowData) { (galleryArray: GalleryResponse) in

            self.albums = galleryArray.data
            self.tableView.reloadData()
            print("\(self.albums[1].postId)---------------------------")
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainAlbumCell", for: indexPath) as? AlbumsCell else {
            return UITableViewCell()
        }

        cell.setup(with: albums[indexPath.row])

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAlbum = albums[indexPath.row]

        performSegue(withIdentifier: "AlbumSegue", sender: selectedAlbum)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AlbumSegue" {
            guard let destination = segue.destination as? AlbumTableViewController else { return }
            guard let castedSender = sender as? Post else { return }
            destination.album = castedSender
        }
    }
}
