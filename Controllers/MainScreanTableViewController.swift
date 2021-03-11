//
//  MainScreanTableViewController.swift
//  someAPIMadness
//
//  Created by Nizelan on 04.03.2021.
//  Copyright © 2021 Nizelan. All rights reserved.
//

import UIKit

class MainScreanTableViewController: UITableViewController, AlbumTableVCDelegate {

    private let networkManager = NetworkManager()

    var page = 1
    var sections = "hot"
    var sort = "top"
    var window = "viral"
    var albums = [Post]()
    var selectedAlbum = 0
    var index = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 400
        tableView.register(UINib(nibName: "FirstAlbumCell", bundle: nil), forCellReuseIdentifier: "FirstAlbumCell")

        fetchAlbums()
    }

    func scrollToRow(currentRow: Int) {
        let index = IndexPath(row: currentRow, section: 0)
        tableView.scrollToRow(at: index, at: .middle, animated: false)
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
            page += 1
            fetchAlbums()
        }

        hideTabBar(index: indexPath.row)
        cell.setup(with: self.albums[indexPath.row]) { () -> Bool in
            return indexPath == self.tableView.indexPath(for: cell)
        }
        tableView.sizeThatFits(self.albums[indexPath.row].coverSize)

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
            destination.delegate = self
        }
    }
}

extension MainScreanTableViewController {
    private func fetchAlbums() {
        self.networkManager.fetchGallery(
            sections: SettingsData.sectionsData, sort: SettingsData.sortData,
            window: SettingsData.windowData, page: page
        ) { (galleryArray: GalleryResponse) in
            self.albums += galleryArray.data

            self.tableView.reloadData()
        }
    }

    func hideTabBar(index: Int) {
        if self.index < index {
            self.index += 1
            tabBarController?.tabBar.isHidden = true
        } else if self.index > index {
            self.index -= 1
            tabBarController?.tabBar.isHidden = false
        }
    }
}
