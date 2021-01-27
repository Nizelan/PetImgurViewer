//
//  AlbumCell.swift
//  someAPIMadness
//
//  Created by Nizelan on 14.01.2021.
//  Copyright © 2021 Nizelan. All rights reserved.
//

import UIKit

protocol AlbumCellDelegate {
    func goToVideoButtonPrassed(cell: UITableViewCell)
    func goToCommentButtonPrassed(cell: UITableViewCell)
}

class AlbumCell: UITableViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var albumImageView: ScalingImageView!
    @IBOutlet weak var goToVideoButton: UIButton!
    var delegate: AlbumCellDelegate?

    var aspectRatioConstraint: NSLayoutConstraint? {
        didSet {
            if let old = oldValue {
                albumImageView.removeConstraint(old)
                //NSLayoutConstraint.deactivate([old])
            }
            if let constraint = aspectRatioConstraint {
                albumImageView.addConstraint(constraint)
                //NSLayoutConstraint.activate([constraint])
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        aspectRatioConstraint = nil
    }

    func setup(with album: Post) {
        setupImage(with: album)
    }

    private func setupImage(with album: Post) {
        guard let imageLink = album.coverImageLink else {
            return
        }

        print("aspect ratio --- \(album.aspectRatio)")
        albumImageView.translatesAutoresizingMaskIntoConstraints = false
        print("===========>\(albumImageView)")
        albumImageView.imageSize = album.coverSize
        self.setNeedsLayout()
        self.layoutIfNeeded()

        if imageLink.contains("mp4") {
            albumImageView.image = UIImage(named: "placeholder")
        } else {
            self.startActivity()
            albumImageView.loadImage(from: imageLink, completion: { (success) in
                self.stopActivity()
                if success {
                    print("successfully loaded image with url: \(imageLink)")
                } else {
                    print("failed to load image with url: \(imageLink)")
                }
            })
        }
    }

    private func setupButtons() {
    }

    private func startActivity() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }

    private func stopActivity() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }

    @IBAction func goToComments(_ sender: UIButton) {
        delegate?.goToCommentButtonPrassed(cell: self)
    }

    @IBAction func goToVideo(_ sender: Any) {
        delegate?.goToVideoButtonPrassed(cell: self)
    }

}
