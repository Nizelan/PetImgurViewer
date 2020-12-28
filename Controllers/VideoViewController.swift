//
//  ViewController.swift
//  someAPIMadness
//
//  Created by Nizelan on 14.12.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoViewController: UIViewController {

    var name: String?
    var link: String?

    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var videoPlayer: CustomVideoPlayer!
    @IBOutlet weak var playButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        videoPlayer.videoLink = link
        setupTitle(title: name)
    }

    func playVideo() {
        guard let imageLink = link else { return }
        if imageLink.contains("mp4") {
            let url = URL(string: imageLink)
            let player = AVPlayer(url: url!)
            let vc = AVPlayerViewController()
            vc.player = player

            present(vc, animated: true) {
                vc.player?.play()
            }
        }
    }

    @IBAction func playButtonAction(_ sender: Any) {
        if videoPlayer.player!.timeControlStatus == .playing {
            playButton.setImage(UIImage(named: "PlayButton"), for: .normal)
            videoPlayer.pause()
        } else {
            playButton.setImage(UIImage(named: "PauseButton"), for: .normal)
            videoPlayer.play()
        }
    }

    func setupTitle(title: String?) {
        if name == nil {
            titleLable.isHidden = true
        } else {
            titleLable.text = name
        }
    }
}
