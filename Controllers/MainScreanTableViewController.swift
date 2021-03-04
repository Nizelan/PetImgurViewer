//
//  MainScreanTableViewController.swift
//  someAPIMadness
//
//  Created by Nizelan on 04.03.2021.
//  Copyright © 2021 Nizelan. All rights reserved.
//

import UIKit

class MainScreanTableViewController: UITableViewController {
    private let networkManager = NetworkManager()

    var pages = 1
    var sections = "hot"
    var sort = "top"
    var window = "viral"
    var albums = [Post]()
    var selectedAlbum = 0

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

        if indexPath.row == (albums.count - 3) {
            pages += 1
            fetchingAlbums()
        }

        cell.setup(with: albums[indexPath.row])
        tableView.sizeThatFits(albums[indexPath.row].coverSize)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAlbum = indexPath.row

        performSegue(withIdentifier: "ShowAlbum", sender: Any?.self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAlbum" {
            guard let destination = segue.destination as? AlbumTableViewController else { return }
            destination.selectedAlbum = selectedAlbum
            destination.albums = albums
        }
    }
}

extension MainScreanTableViewController {
    private func fetchingAlbums() {
        self.networkManager.fetchGallery(
            sections: SettingsData.sectionsData, sort: SettingsData.sortData,
            window: SettingsData.windowData, page: pages
        ) { (galleryArray: GalleryResponse) in
            self.albums += galleryArray.data

            self.tableView.reloadData()
        }
    }
}
