//
//  MainScreanViewController.swift
//  someAPIMadness
//
//  Created by Nizelan on 17.02.2021.
//  Copyright © 2021 Nizelan. All rights reserved.
//

import UIKit

class MainScreanViewController: UIViewController, MainScreanTabelViewDelegate {

    private let networkManager = NetworkManager()
    var dataSource: (UITableViewDataSource & UITableViewDelegate)?

    private var pages = 1
    var sections = "hot"
    var sort = "top"
    var window = "viral"
    var albums: [Post] = []
    var selectedAlbum: Int?

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchingAlbums()
    }

    func updateData() {
        pages += 1
        fetchingAlbums()
    }

    func didSelectRow(selectedAlbum: Int) {
        self.selectedAlbum = selectedAlbum
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

extension MainScreanViewController {
    private func fetchingAlbums() {
        self.networkManager.fetchGallery(
            sections: SettingsData.sectionsData,
            sort: SettingsData.sortData,
            window: SettingsData.windowData,
            page: pages
        ) { (galleryArray: GalleryResponse) in
            self.albums += galleryArray.data

            self.dataSource = MainScreanTableView(albums: self.albums, tableView: self.tableView, delegate: self)
            self.setupTableView()
            self.tableView.reloadData()
        }
    }

    private func setupTableView() {
        self.tableView.delegate = self.dataSource
        self.tableView.dataSource = self.dataSource
        self.tableView.reloadData()
    }
}
