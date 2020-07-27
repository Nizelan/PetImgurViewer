//
//  AlbumTableViewController.swift
//  someAPIMadness
//
//  Created by Nizelan on 27.07.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit

class AlbumTableViewController: UITableViewController {

    var openedAlbum = [GalleryEntry]()
    let mainTable = MainTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 400
        openedAlbum = mainTable.albums
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

}
