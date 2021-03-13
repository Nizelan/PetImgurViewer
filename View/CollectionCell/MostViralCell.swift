//
//  MostViralCell.swift
//  someAPIMadness
//
//  Created by Nizelan on 10.03.2021.
//  Copyright © 2021 Nizelan. All rights reserved.
//

import UIKit

class MostViralCell: UICollectionViewCell {

    @IBOutlet weak var viralImageView: ScalingImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ptsLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var currentIndexPath = IndexPath(item: -1, section: -1)

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(with album: Post, isCellVisible: @escaping () -> Bool) {
        self.layer.cornerRadius = 5
        self.backgroundColor = .gray
        setupImage(with: album, isCellVisible: isCellVisible)
        setupTitle(with: album)
        setupPts(with: album)
    }

    private func setupImage(with album: Post, isCellVisible: @escaping () -> Bool) {
        guard let link = album.coverLink(index: 0) else { return }
        startActivity()

        viralImageView.imageSize = album.coverSize

        if link.contains("mp4") {
            viralImageView.image = UIImage(named: "playVideo")
            stopActivity()
        } else {
            viralImageView.loadImage(from: link, completion: { (success) in
                if success {
                    self.stopActivity()
                    print("successfully loaded image with url: \(link)")
                } else {
                    print("failed to load image with url: \(link)")
                }
            }, shouldAssignImage: isCellVisible)
        }
    }

    private func setupTitle(with album: Post) {
        titleLabel.text = album.title
    }

    private func setupPts(with album: Post) {
        if let ups = album.ups, let downs = album.downs {
            ptsLabel.text = String(ups - downs)
        }
    }

    private func startActivity() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    private func stopActivity() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
}
