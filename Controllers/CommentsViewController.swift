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
        commentCell.nameLabel.text = authors[indexPath.row]
        commentCell.commentLabel.text = comments[indexPath.row]
        if let linc = lincFinder(string: comments[indexPath.row]) {
            if linc.contains("gif") {
                commentCell.commentImegeView.loadGif(url: linc)
            }
        }
        commentCell.ptsLabel.text = String(points[indexPath.row]) + " " + "pts"
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

    func lincFinder(string: String) -> String? {
        let input = string
        var urlString = String()

        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let maches = detector?.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count)) {
            for mach in maches {
                guard let range = Range(mach.range, in: input) else { continue }
                let url = input[range]
                urlString = String(url)
            }
        }
        return urlString
    }
}
