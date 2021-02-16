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
    private var pages = 1
    var sections = "hot"
    var sort = "top"
    var window = "viral"
    var albums = [Post]()
    var imagesCount = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "FirstAlbumCell", bundle: nil), forCellReuseIdentifier: "FirstAlbumCell")

        fetchingAlbums()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =
            tableView.dequeueReusableCell(withIdentifier: "FirstAlbumCell", for: indexPath) as? FirstAlbumCell else {
            return UITableViewCell()
        }

        if indexPath.row == (albums.count - 1) {
            pages += 1
            fetchingAlbums()
        }

        cell.setup(with: albums[indexPath.row])
        tableView.sizeThatFits(albums[indexPath.row].coverSize)

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

extension MainTableViewController {
    private func fetchingAlbums() {
        self.networkManager.fetchGallery(
            sections: SettingsData.sectionsData, sort: SettingsData.sortData,
            window: SettingsData.windowData, page: pages
        ) { (galleryArray: GalleryResponse) in

            self.albums += galleryArray.data
            self.tableView.reloadData()
            print("\(self.albums[1].postId)---------------------------")
        }
    }
}
