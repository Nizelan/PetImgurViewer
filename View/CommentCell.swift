//
//  CommentCell.swift
//  someAPIMadness
//
//  Created by Nizelan on 15.10.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var ptsLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutMargins.left = CGFloat(self.indentationLevel) * self.indentationWidth
        self.contentView.layoutIfNeeded()
    }
}
