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
    var comments = [CommentInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let albumID = albumID {
            self.networkManager.fetchComment(sort: "best", id: albumID) { (commentArray: GalleryCommentResponse) in
                self.comments = commentArray.data
                self.tableView.reloadData()
            }
        }
        print("\(albumID)*******************************")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return comments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? UITableViewCell else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = self.comments[indexPath.row].author
        cell.detailTextLabel?.text = self.comments[indexPath.row].comment
        
        return cell
    }
}
