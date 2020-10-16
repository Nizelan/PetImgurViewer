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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let albumID = albumID {
            self.networkManager.fetchComment(sort: "best", id: albumID) { (commentArray: GalleryCommentResponse) in
                self.commentsInfo = commentArray.data
                self.decomposeCommentInfo(commentsArray: self.commentsInfo)
                self.tableView.reloadData()
            }
        }
        print("\(albumID)*******************************")
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return authors.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let commentCell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCell else { return UITableViewCell()
        }
        commentCell.indentationLevel = commentLVLs[indexPath.row]
        commentCell.textLabel?.text = authors[indexPath.row]
        commentCell.detailTextLabel?.text = comments[indexPath.row]
        
        return commentCell
    }
    
    func decomposeCommentInfo(commentsArray: [CommentInfo]) {
        var indentationLevel = 0
        for index in 0..<commentsArray.count {
            authors.append(commentsArray[index].author)
            comments.append(commentsArray[index].comment)
            commentLVLs.append(indentationLevel)
            points.append(commentsArray[index].points)
            if let children = commentsArray[index].children {
                indentationLevel += 1
                decomposeCommentInfo(commentsArray: children)
            }
        }
    }
}
