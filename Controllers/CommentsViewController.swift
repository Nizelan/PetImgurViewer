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
    var comments = [Comment]()
    var indentLVLs = [Int]()
    var indentationLevel = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension

        if let albumID = albumID {
            self.networkManager.fetchComment(sort: "best", id: albumID) { (commentArray: GalleryCommentResponse) in
                self.comments = commentArray.data
                self.createIndentArray(commentsArray: self.comments)
                self.tableView.reloadData()

            }
        }
        print("\(String(describing: albumID))*******************************")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return indentLVLs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let commentCell = tableView.dequeueReusableCell(withIdentifier: "CommentCell",
                                                              for: indexPath) as? CommentCell else { return UITableViewCell() }
        var dummy = 0
        if let currentComment = cm(at: indexPath.row, currentIndex: &dummy, in: comments) {
            commentCell.setupCell(comment: currentComment,
                                  indentLVL: indentLVLs[indexPath.row],
                                  urlString: currentComment.linkFinder())

            return commentCell
        }
        return commentCell
    }

    func createIndentArray(commentsArray: [Comment]) {
        for index in 0..<commentsArray.count {
            if let children = commentsArray[index].children {
                indentationLevel += 1
                indentLVLs.append(indentationLevel)
                createIndentArray(commentsArray: children)
                indentationLevel -= 1
            } else {
                indentLVLs.append(indentationLevel)
            }
        }
    }

    func cm(at row: Int, currentIndex: inout Int, in array: [Comment]) -> Comment? {
        for comment in array {
            if currentIndex == row {
                return comment
            }
            currentIndex += 1
            print(currentIndex)
            if comment.children!.count != 0,
                let foundIt = cm(at: row, currentIndex: &currentIndex, in: comment.children!) {
                return foundIt
            }
        }

        return nil
    }
}
