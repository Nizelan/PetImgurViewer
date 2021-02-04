//
//  CustomVideoView.swift
//  someAPIMadness
//
//  Created by Nizelan on 17.12.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit
import AVKit

class CustomVideoPlayer: UIView {

    @IBOutlet weak var vwPlayer: UIView!
    var player: AVPlayer?

//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        commonInit()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        commonInit()
//    }
//
//    fileprivate func commonInit() {
//        if let viewFromXib = Bundle.main.loadNibNamed("CustomVideoPlayer", owner: self, options: nil)![0] as? UIView {
//            viewFromXib.frame = self.bounds
//            addSubview(viewFromXib)
//            addPlayerToView(self.vwPlayer)
//        }
//
//    }

    fileprivate func addPlayerToView(_ view: UIView) {
        player = AVPlayer()
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.bounds
        playerLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(playerLayer)
        NotificationCenter.default.addObserver(self, selector: #selector(playerEndPlay),
                                               name: .AVPlayerItemDidPlayToEndTime, object: nil)
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
