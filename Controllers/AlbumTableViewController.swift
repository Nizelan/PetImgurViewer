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

class AlbumTableViewController: UITableViewController, AlbumCellDelegate {

    var album: Post?
    let networkManager = NetworkManager()
    var id: String?
    var name: String?
    var link = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 400
        id = album!.postId

        tableView.register(UINib(nibName: "SecongAlbumCell", bundle: nil), forCellReuseIdentifier: "SecongAlbumCell")
        tableView.reloadData()
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "SecongAlbumCell",
                                                     for: indexPath) as? SecongAlbumCell else {
                return UITableViewCell()
        }

        cell.delegate = self
        cell.setup(with: album)

        return cell
    }

    func goToVideoButtonPrassed(cell: UITableViewCell) {
        guard let indexPathRow = tableView.indexPath(for: cell)?.row else {
            print("\(Self.self) now have cell")
            return
        }
        let url = album!.images![indexPathRow].link
        let title = album!.title
        link = url
        name = title
        performSegue(withIdentifier: "ShowVideo", sender: Any?.self)
    }

    func goToCommentButtonPrassed(cell: UITableViewCell) {
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
