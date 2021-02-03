//
//  CollectionFavoritesCell.swift
//  someAPIMadness
//
//  Created by Nizelan on 05.12.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit

protocol AccFavoritesCellDelegate {
    func playButtonPressed(cell: UITableViewCell)
}

class AccFavoritesCell: UITableViewCell {

    @IBOutlet weak var favoriteImageView: ScalingImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var ups: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var goToVideos: UIButton!
    var delegate: AccFavoritesCellDelegate?

    func setup(with album: FavoritePost) {
        setupImage(with: album)
        self.ups.text = String(album.points)

        if let title = album.title {
            self.title.text = title
        } else {
            self.title.isHidden = true
        }
    }

    private func setupImage(with album: FavoritePost) {
        let imageLink = album.link

        print("aspect ratio --- \(album.aspectRatio)")
        favoriteImageView.translatesAutoresizingMaskIntoConstraints = false
        print("===========>\(favoriteImageView)")
        favoriteImageView.imageSize = album.coverSize
        self.setNeedsLayout()
        self.layoutIfNeeded()

        if let videoLink = album.images[0].mp4 {
            goToVideos.isHidden = false
            stopActivity()
        } else {
            goToVideos.isHidden = true
            self.startActivity()
            favoriteImageView.loadImage(from: imageLink, completion: { (success) in
                self.stopActivity()
                if success {
                    print("successfully loaded image with url: \(imageLink)")
                } else {
                    print("failed to load image with url: \(imageLink)")
                }
            })
        }
    }

    @IBAction func goToVideo(_ sender: Any) {
        delegate?.playButtonPressed(cell: self)
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
