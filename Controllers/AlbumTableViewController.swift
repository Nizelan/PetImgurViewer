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

protocol AlbumTableVCDelegate: class {
    func scrollToRow(currentRow: Int)
}

class AlbumTableViewController: UITableViewController, AlbumCellDelegate {

    let networkManager = NetworkManager()
    weak var delegate: AlbumTableVCDelegate?
    var albumId: String?
    var name: String?
    var link = String()

    var albums: [Post]?
    var selectedAlbum = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .gray
        tableView.rowHeight = 400
        tableView.rowHeight = UITableView.automaticDimension
        self.title = albums?[selectedAlbum].title
        albumId = albums![selectedAlbum].postId

        tableView.register(UINib(nibName: "SecongAlbumCell", bundle: nil), forCellReuseIdentifier: "SecongAlbumCell")
        tableView.reloadData()

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(moveToNextItem))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(moveToNextItem))
        swipeLeft.direction = .left
        swipeRight.direction = .right

        tableView.addGestureRecognizer(swipeLeft)
        tableView.addGestureRecognizer(swipeRight)
    }

    override func viewWillDisappear(_ animated: Bool) {
        delegate?.scrollToRow(currentRow: selectedAlbum)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = albums?[selectedAlbum].images?.count else { return 0 }
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let album = albums?[selectedAlbum],
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "SecongAlbumCell",
                for: indexPath
                ) as? SecongAlbumCell else {
                    return UITableViewCell()
        }

        cell.delegate = self

        cell.setup(with: album, index: indexPath.row) { () -> Bool in
            return indexPath == self.tableView.indexPath(for: cell)
        }

        return cell
    }

    @objc func moveToNextItem(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .left:
            selectedAlbum += 1
            self.title = albums?[selectedAlbum].title
            self.tableView.reloadData()
        case .right:
            if selectedAlbum != 0 {
                selectedAlbum -= 1
                self.title = albums?[selectedAlbum].title
                self.tableView.reloadData()
            }
        default: break
        }
    }

    func goToVideoButtonPrassed(cell: UITableViewCell) {
        guard let indexPathRow = tableView.indexPath(for: cell)?.row else {
            print("\(Self.self) now have cell")
            return
        }
        guard let url = albums?[selectedAlbum].images![indexPathRow].link else {
            print("\(Self.self) ERROR: This album has now have link")
            return
        }
        guard let title = albums?[selectedAlbum].title else {
            print("\(Self.self) ERROR: This album has now have link")
            return
        }
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
            destination.albumID = albumId
        } else if segue.identifier == "ShowVideo" {
            guard let destination = segue.destination as? VideoViewController else { return }
            destination.name = name
            destination.link = link
        }
    }
}
