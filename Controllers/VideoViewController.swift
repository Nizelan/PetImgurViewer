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
    var isFirst = true

    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var videoPlayer: CustomVideoPlayer!
    @IBOutlet weak var volumeSlider: UISlider!
    var playButton = UIButton()
    var videoProgresSlider = UISlider()

    override func viewDidLoad() {
        super.viewDidLoad()
        videoPlayer.videoLink = link
        setupTitle(title: name)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //PlayBtton
        playButton.frame.size = CGSize(width: 50, height: 50)
        playButton.backgroundColor = .none
        playButton.setImage(UIImage(named: "PlayButton"), for: .normal)
        playButton.tintColor = UIColor.white
        playButton.addTarget(self, action: #selector(self.playPauseButtonAction(_:)), for: .touchUpInside)

        videoPlayer.addSubview(playButton)

        //Slider
        videoProgresSlider.minimumValue = 0

        if let itemDuration = videoPlayer.player?.currentItem?.duration {
            let seconds: Float64 = CMTimeGetSeconds(itemDuration)
            videoProgresSlider.maximumValue = Float(seconds)
        }

        videoProgresSlider.isContinuous = true
        videoProgresSlider.tintColor = UIColor.red

        videoProgresSlider.addTarget(self, action: #selector(self.videoProgresSliderAction(_:)), for: .valueChanged)
        videoPlayer.addSubview(videoProgresSlider)

        //Constrainst
        videoPlayer.translatesAutoresizingMaskIntoConstraints = false
        playButton.translatesAutoresizingMaskIntoConstraints = false
        videoProgresSlider.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLable.heightAnchor.constraint(equalToConstant: 21),

            videoPlayer.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 8),
            videoPlayer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            videoPlayer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            videoPlayer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            playButton.centerXAnchor.constraint(equalTo: videoPlayer.centerXAnchor),
            playButton.bottomAnchor.constraint(equalTo: videoPlayer.bottomAnchor, constant: -8),

            videoProgresSlider.heightAnchor.constraint(equalToConstant: 33),
            videoProgresSlider.widthAnchor.constraint(equalToConstant: 300),
            videoProgresSlider.bottomAnchor.constraint(equalTo: playButton.topAnchor, constant: -8),
            videoProgresSlider.centerXAnchor.constraint(equalTo: videoPlayer.centerXAnchor)
        ])

        videoPlayer.player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 10000),
                                                    queue: .main, using: { (time) in
                                                        self.videoProgresSlider.value = Float(time.seconds)
        })
    }

    override func viewWillDisappear(_ animated: Bool) {
        videoPlayer.pause()
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
