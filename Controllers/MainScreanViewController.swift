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
    var albums = [Post]()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var goToAuthorization: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchingAlbums()
    }

    func updateData() {
        pages += 1
        fetchingAlbums()
    }

    func didSelectRow(album: Post) {
        let secondAlbumVC =
            storyboard?.instantiateViewController(identifier: "SecondAlbumVC") as? AlbumTableViewController
        secondAlbumVC?.album = album
        self.present(secondAlbumVC!, animated: true)
    }

    @IBAction func goToAuthorization(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowAuthorization", sender: Any?.self)
    }
}

extension MainScreanViewController {
    private func fetchingAlbums() {
        self.networkManager.fetchGallery(
            sections: SettingsData.sectionsData, sort: SettingsData.sortData,
            window: SettingsData.windowData, page: pages
        ) { (galleryArray: GalleryResponse) in
            self.albums += galleryArray.data

            self.dataSource = MainScreanTableView(albums: self.albums, tableView: self.tableView, delegate: self)
            self.setupTableView()
            self.tableView.reloadData()
            print("\(self.albums[1].postId)---------------------------")
        }
    }

    private func setupTableView() {
        self.tableView.delegate = self.dataSource
        self.tableView.dataSource = self.dataSource
        self.tableView.reloadData()
    }
}
