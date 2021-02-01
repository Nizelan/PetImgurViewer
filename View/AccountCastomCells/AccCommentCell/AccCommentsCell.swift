//
//  AccCommentsTableViewCell.swift
//  someAPIMadness
//
//  Created by Nizelan on 04.12.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit

class AccCommentsCell: UITableViewCell {

    @IBOutlet weak var accAuthorName: UILabel!
    @IBOutlet weak var accComment: UILabel!
    @IBOutlet weak var accCommPts: UILabel!

    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutMargins.left = CGFloat(self.indentationLevel) * self.indentationWidth
        self.contentView.layoutIfNeeded()
    }

    func setup(comment: AccComment, indentLVL: Int) {
        self.contentView.layoutMargins.left = CGFloat(self.indentationLevel) * self.indentationWidth
        self.indentationLevel = indentLVL
        accAuthorName.text = comment.author
        accComment.text = comment.comment
        accCommPts.text = String(comment.points) + " " + "pts"
    }
}
