//
//  AccPostsCell.swift
//  someAPIMadness
//
//  Created by Nizelan on 05.12.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit

protocol AccPostCellDelegate {
    func playButtonPrassed(cell: UITableViewCell)
    func commentButtomPrassed(cell: UITableViewCell)
}

class AccPostCell: UITableViewCell {

    @IBOutlet weak var postImage: ScalingImageView!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var shoveVideo: UIButton!
    @IBOutlet weak var shoveComment: UIButton!
    var delegate: AccPostCellDelegate?

    func setup(with album: AccPost) {
        setupImage(with: album)

        if let title = album.title {
            postTitle.text = title
        } else {
            postTitle.isHidden = true
        }
    }

    private func setupImage(with album: AccPost) {
        let imageLink = album.link

        print("aspect ratio --- \(album.aspectRatio)")
        postImage.translatesAutoresizingMaskIntoConstraints = false
        postImage.imageSize = album.coverSize
        self.setNeedsLayout()
        self.layoutIfNeeded()

        if imageLink.contains("mp4") {
            shoveVideo.isHidden = true
            stopActivity()
        } else {
            self.shoveVideo.isHidden = true
            self.startActivity()
            postImage.loadImage(from: imageLink, completion: { (success) in
                self.stopActivity()
                if success {
                    print("successfully loaded image with url: \(imageLink)")
                } else {
                    print("failed to load image with url: \(imageLink)")
                }
            })
        }
    }

    @IBAction func playButtonAction(_ sender: UIButton) {
        delegate?.playButtonPrassed(cell: self)
    }

    @IBAction func commentsButtonAction(_ sender: UIButton) {
        delegate?.commentButtomPrassed(cell: self)
    }

    private func startActivity() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }

    private func stopActivity() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
}