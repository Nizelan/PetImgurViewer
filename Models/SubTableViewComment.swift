//
//  TableView.swift
//  someAPIMadness
//
//  Created by Nizelan on 12.10.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit

class SubTableViewComment: UITableView, UITableViewDelegate, UITableViewDataSource {

    var commentsArray: [CommentInfo]
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let commentCell = tableView.dequeueReusableCell(withIdentifier: "CommentCell",
                                        for: indexPath) as? CommentCell else { return UITableViewCell() }

        commentCell.nameLabel.text = commentsArray[indexPath.row].author
        commentCell.commentLabel.text = commentsArray[indexPath.row].comment
        return commentCell
    }
}
