//
//  CommentCellWI.swift
//  someAPIMadness
//
//  Created by Nizelan on 23.10.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit

class CommentCellWI: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var ptsLabel: UILabel!

    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutMargins.left = CGFloat(self.indentationLevel) * self.indentationWidth
        self.contentView.layoutIfNeeded()
    }

    func setupCellWI(name: String, comment: String, pts: Int, indentLVL: Int) {
        self.indentationLevel = indentLVL
        self.nameLabel.text = name
        self.commentLabel.text = comment
        self.ptsLabel.text = String(pts) + " " + "pts"
    }
}
