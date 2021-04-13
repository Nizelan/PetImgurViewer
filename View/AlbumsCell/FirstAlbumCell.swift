import UIKit

class FirstAlbumCell: UITableViewCell {
    @IBOutlet weak var imageViewOutlet: ScalingImageView!
    @IBOutlet weak var upsLabel: UILabel!
    @IBOutlet weak var imageNamelable: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var upsImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }

    func setup(with album: Post, isCellVisible: @escaping () -> Bool) {
        self.layer.cornerRadius = 10
        setupImage(with: album, isCellVisible: isCellVisible)
        setupUps(album)

        if let title = album.title {
            imageNamelable.text = title
        } else {
            imageNamelable.isHidden = true
        }
    }

    private func setupImage(with album: Post, isCellVisible: @escaping () -> Bool) {
        guard let imageLink = album.coverLink(index: 0) else { return }

        imageViewOutlet.imageSize = album.coverSize

        if imageLink.contains("mp4") {
            imageViewOutlet.image = UIImage(named: "playVideo")
        } else {
            self.startActivity()
            imageViewOutlet.loadImage(from: imageLink, completion: { success in
                if success {
                    self.stopActivity()
                    print("successfully loaded image with url: \(imageLink)")
                } else {
                    print("failed to load image with url: \(imageLink)")
                }
            }, shouldAssignImage: isCellVisible)
        }
    }

    private func setupUps(_ album: Post) {
        guard let ups = album.ups, let downs = album.downs else {
            upsLabel.isHidden = true
            upsImage.isHidden = true
            return
        }

        upsLabel.text = String(ups - downs) + " " + "points"
    }

    func startActivity() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }

    func stopActivity() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
}
