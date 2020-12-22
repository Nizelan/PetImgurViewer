//
//  AccPostsCell.swift
//  someAPIMadness
//
//  Created by Nizelan on 05.12.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit

class AccPostsCell: UITableViewCell {

    @IBOutlet weak var postImage: ScalingImageView!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var postVideo: CustomVideoPlayer!
    @IBOutlet weak var playPost: UIButton!

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
        print("===========>\(postImage)")
        postImage.imageSize = album.coverSize
        self.setNeedsLayout()
        self.layoutIfNeeded()

        if imageLink.contains("mp4") {
            postVideo.playWithLink(imageLink, ofType: "mp4")
            playPost.isHidden = true
            stopActivity()
        } else {
            self.postVideo.isHidden = true
            self.playPost.isHidden = true
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

    private func startActivity() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }

    private func stopActivity() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
}
