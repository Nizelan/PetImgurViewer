//
//  CommentsViewController.swift
//  someAPIMadness
//
//  Created by Nizelan on 08.10.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit

class CommentsViewController: UITableViewController {
    private let networkManager = NetworkManager()
    var albumID: String?
    var commentsInfo = [CommentInfo]()
    var authors = [String]()
    var comments = [String]()
    var commentLVLs = [Int]()
    var points = [Int]()
    var indentationLevel = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        if let albumID = albumID {
            self.networkManager.fetchComment(sort: "best", id: albumID) { (commentArray: GalleryCommentResponse) in
                self.commentsInfo = commentArray.data
                self.decomposeCommentInfo(commentsArray: self.commentsInfo)
                self.tableView.reloadData()

            }
        }
        print("\(String(describing: albumID))*******************************")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return authors.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let commentCell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCell else { return UITableViewCell() }

        commentCell.indentationLevel = commentLVLs[indexPath.row]
        commentCell.ptsLabel.text = String(points[indexPath.row]) + " " + "pts"
        commentCell.nameLabel.text = authors[indexPath.row]
        commentCell.commentLabel.text = comments[indexPath.row]
        return commentCell
    }

    func decomposeCommentInfo(commentsArray: [CommentInfo]) {
        for index in 0..<commentsArray.count {
            authors.append(commentsArray[index].author)
            comments.append(commentsArray[index].comment)
            points.append(commentsArray[index].points)
            if let children = commentsArray[index].children {
                indentationLevel += 1
                commentLVLs.append(indentationLevel)
                decomposeCommentInfo(commentsArray: children)
                indentationLevel -= 1
            } else {
                commentLVLs.append(indentationLevel)
            }
        }
    }
}
