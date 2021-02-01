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

class SecongAlbumCell: UITableViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var albumImageView: ScalingImageView!
    @IBOutlet weak var goToVideoButton: UIButton!
    @IBOutlet weak var goToComments: UIButton!
    var delegate: AlbumCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }

    func setup(with album: Post) {
        setupImage(with: album)
        setupButtons(with: album)
    }

    private func setupImage(with album: Post) {
        guard let imageLink = album.coverImageLink else {
            return
        }

        albumImageView.imageSize = album.coverSize

        if imageLink.contains("mp4") {
            albumImageView.image = UIImage(named: "playVideo")
            stopActivity()
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

    private func setupButtons(with album: Post) {
        if album.coverImageLink!.contains("mp4") {
            goToVideoButton.isHidden = false
        } else {
            goToVideoButton.isHidden = true
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

    @IBAction func goToComments(_ sender: UIButton) {
        delegate?.goToCommentButtonPrassed(cell: self)
    }

    @IBAction func goToVideo(_ sender: Any) {
        delegate?.goToVideoButtonPrassed(cell: self)
    }

}
