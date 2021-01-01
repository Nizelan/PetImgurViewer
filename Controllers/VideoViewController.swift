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
    var link = "https://i.imgur.com/duy0rqX.mp4"
    var isFirst = true

    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var videoPlayer: CustomVideoPlayer!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var videoProgresSlider: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()
        videoPlayer.videoLink = link
        setupTitle(title: name)
        videoPlayer.player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 10000),
                                                    queue: .main, using: { (time) in
                                                        self.videoProgresSlider.value = Float(time.seconds)
        })
    }

    @IBAction func playPauseButtonAction(_ sender: Any) {
        if videoProgresSlider.value == videoProgresSlider.maximumValue {
            videoPlayer.player?.seek(to: CMTime(seconds: 0, preferredTimescale: 1000))
        }

        if videoPlayer.player!.timeControlStatus == .playing {
            playButton.setImage(UIImage(named: "PlayButton"), for: .normal)
            videoPlayer.pause()
        } else {
            playButton.setImage(UIImage(named: "PauseButton"), for: .normal)
            videoPlayer.play()
            if isFirst {
                setupProgressVideoSlider()
            }
        }
    }

    @IBAction func playFaster(_ sender: Any) {
        if videoPlayer.player?.currentItem?.currentTime() == videoPlayer.player?.currentItem?.duration {
            videoPlayer.player?.currentItem?.seek(to: .zero, completionHandler: nil)
        }
        videoPlayer.player?.rate = min(videoPlayer.player!.rate + 2.0, 2.0)
    }

    @IBAction func playBackward(_ sender: Any) {
        if videoPlayer.player?.currentItem?.currentTime() == .zero {
            if let itemDuration = videoPlayer.player?.currentItem?.duration {
                videoPlayer.player?.currentItem?.seek(to: itemDuration, completionHandler: nil)
            }
        }
        videoPlayer.player?.rate = max(videoPlayer.player!.rate - 2.0, -2.0)
    }

    @IBAction func volumeAction(_ sender: UISlider) {
        videoPlayer.player?.volume = volumeSlider.value
    }

    @IBAction func videoProgresSliderAction(_ sender: Any) {
        videoPlayer.player?.seek(to: CMTime(seconds: Double(videoProgresSlider.value), preferredTimescale: 1000))
    }

    func setupTitle(title: String?) {
        if name == nil {
            titleLable.isHidden = true
        } else {
            titleLable.text = name
        }
    }
}

extension VideoViewController {

    func setupProgressVideoSlider() {
        guard let duration = self.videoPlayer.player?.currentItem?.asset.duration.seconds else {
            print("\(Self.self) error: now have Current Item duration time")
            return
        }
        self.videoProgresSlider.maximumValue = Float(duration)
    }
}
