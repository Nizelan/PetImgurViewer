//
//  AlbumCell.swift
//  someAPIMadness
//
//  Created by Nizelan on 14.01.2021.
//  Copyright © 2021 Nizelan. All rights reserved.
//

import UIKit

protocol AlbumCellDelegate: class {
    func goToVideoButtonPrassed(cell: UITableViewCell)
    func goToCommentButtonPrassed(cell: UITableViewCell)
}

class SecongAlbumCell: UITableViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var albumImageView: ScalingImageView!
    @IBOutlet weak var goToVideoButton: UIButton!
    @IBOutlet weak var goToComments: UIButton!

    weak var delegate: AlbumCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }

    func setup(with album: Post, index: Int, isVisible: @escaping () -> Bool) {
        setupImage(with: album, index: index, isVisible: isVisible)
        setupButtons(with: album, index: index)
    }

    private func setupImage(with album: Post, index: Int, isVisible: @escaping () -> Bool) {
        guard let imageLink = album.coverLink(index: index) else {
            return
        }
        print("\(imageLink)")

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
            }, shouldAssignImage: nil)
        }
    }

    private func setupButtons(with album: Post, index: Int) {
        if album.coverLink(index: index)!.contains("mp4") {
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
