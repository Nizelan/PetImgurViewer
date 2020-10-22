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
    @IBOutlet weak var commentImageView: UIImageView!

    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutMargins.left = CGFloat(self.indentationLevel) * self.indentationWidth
        self.contentView.layoutIfNeeded()
    }

    func setupCell(name: String, comment: String, pts: Int, indentLVL: Int) -> CommentCell {
        let cell = CommentCell()
        cell.indentationLevel = indentLVL
        cell.nameLabel.text = name
        cell.commentLabel.text = comment
        cell.ptsLabel.text = String(pts) + " " + "pts"
        if let linc = lincFinder(string: comment) {
            if linc.contains("gif") {
                cell.commentImageView.loadGif(url: linc)
                print(linc)
            } else if let imageLinc = lincFinder(string: linc) {
                cell.commentImageView.loadImage(from: imageLinc)
            }
        }
        return cell
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
