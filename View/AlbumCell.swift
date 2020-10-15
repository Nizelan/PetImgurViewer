//
//  AlbumCell.swift
//  someAPIMadness
//
//  Created by Nizelan on 24.07.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit

class AlbumCell: UITableViewCell {
    @IBOutlet weak var imageViewOutlet: ScalingImageView!
    @IBOutlet weak var upsLabel: UILabel!
    @IBOutlet weak var imageNamelable: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var upsImage: UIImageView!

    var aspectRatioConstraint: NSLayoutConstraint? {
        didSet {
            if let old = oldValue {
                imageViewOutlet.removeConstraint(old)
                //NSLayoutConstraint.deactivate([old])
            }
            if let constraint = aspectRatioConstraint {
                imageViewOutlet.addConstraint(constraint)
                //NSLayoutConstraint.activate([constraint])
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        aspectRatioConstraint = nil
    }

    func setup(with album: Post) {
        setupImage(with: album)
        setupUps(album)

        if let title = album.title {
            imageNamelable.text = title
        } else {
            imageNamelable.isHidden = true
        }
    }

    private func setupImage(with album: Post) {
        guard let imageLink = album.coverImageLink else {
            return
        }

        print("aspect ratio --- \(album.aspectRatio)")
        imageViewOutlet.translatesAutoresizingMaskIntoConstraints = false
//        aspectRatioConstraint = NSLayoutConstraint(item: imageViewOutlet,
//                                                   attribute: NSLayoutConstraint.Attribute.width,
//                                                   relatedBy: NSLayoutConstraint.Relation.equal,
//                                                   toItem: imageViewOutlet,
//                                                   attribute: NSLayoutConstraint.Attribute.height,
//                                                   multiplier: album.aspectRatio, constant: 0.0)

        imageViewOutlet.imageSize = album.coverSize
        self.setNeedsLayout()
        self.layoutIfNeeded()

        if imageLink.contains("mp4") {
            imageViewOutlet.image = UIImage(named: "placeholder")
        } else {
            self.startActivity()
            imageViewOutlet.loadImage(from: imageLink, completion: { (success) in
                self.stopActivity()
                if success {
                    print("successfully loaded image with url: \(imageLink)")
                } else {
                    print("failed to load image with url: \(imageLink)")
                }
            })
        }
    }

    private func setupUps(_ album: Post) {
        guard let ups = album.ups,
              let downs = album.downs else {
            upsLabel.isHidden = true
            upsImage.isHidden = true
            return
        }

        upsLabel.text = String(ups - downs) + " " + "points"
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
