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
    @IBOutlet weak var commentImageView: ScalingImageView!
    @IBOutlet weak var ptsLabel: UILabel!

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
            setupImageSize(width: 240, height: 170)
            if link.contains("gif") {
                self.commentImageView.loadGif(url: link)
            } else if let imageLinc = urlString {
                self.commentImageView.loadImage(from: imageLinc, shouldAssignImage: nil)
            }
        } else {
            setupImageSize(width: 0, height: 0)
        }
    }

    func setupImageSize(width: Int, height: Int) {
        commentImageView.translatesAutoresizingMaskIntoConstraints = false
        commentImageView.imageSize = CGSize(width: width, height: height)
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}
