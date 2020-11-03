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
    @IBOutlet weak var commentImageView: ScalingImageView!

    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutMargins.left = CGFloat(self.indentationLevel) * self.indentationWidth
        self.contentView.layoutIfNeeded()
    }

    func setupCell(comment: Comment, indentLVL: Int, urlString: String?) {
        self.indentationLevel = indentLVL
        self.nameLabel.text = comment.author
        self.commentLabel.text = comment.comment
        self.ptsLabel.text = String(comment.points) + " " + "pts"
        if let link = urlString {
            if link.contains("gif") {
                self.commentImageView.loadGif(url: link)
                print(link)
            } else if let imageLinc = urlString {
                self.commentImageView.loadImage(from: imageLinc)
            }
        } else {
            commentImageView.translatesAutoresizingMaskIntoConstraints = false
            commentImageView.imageSize = CGSize(width: 0, height: 0)
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
}
