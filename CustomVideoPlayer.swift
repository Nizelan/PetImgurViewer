import UIKit
import AVKit

class CustomVideoPlayer: UIView {

    @IBOutlet weak var vwPlayer: UIView!
    var player: AVPlayer?

    func addPlayerToView(_ view: UIView) {
        player = AVPlayer()
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.bounds
        playerLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(playerLayer)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerEndPlay),
            name: .AVPlayerItemDidPlayToEndTime,
            object: nil
        )
    }

    func playWithLink(_ videoLink: String, ofType type: String) {
        guard let url = URL(string: videoLink) else { return }
        let playerItem = AVPlayerItem(url: url)
        player?.replaceCurrentItem(with: playerItem)
        player?.play()
    }

    @objc func playerEndPlay() {
        print("Player ends playing video")
    }
}
