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
    var playButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var videoProgresSlider: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()
        videoPlayer.videoLink = link
        setupTitle(title: name)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //PlayBtton
        playButton = UIButton(type: UIButton.ButtonType.system) as UIButton
        let xPostion: CGFloat = (self.videoPlayer.bounds.width / 2) - 25
        let yPostion: CGFloat = self.videoPlayer.bounds.height - 50
        let buttonWidth: CGFloat = 50
        let buttonHeight: CGFloat = 50
        playButton!.frame = CGRect(x: xPostion, y: yPostion, width: buttonWidth, height: buttonHeight)
        playButton!.backgroundColor = UIColor.lightGray
        playButton.setImage(UIImage(named: "PlayButton"), for: .normal)
        playButton!.tintColor = UIColor.black
        playButton!.addTarget(self, action: #selector(self.playButtonTapped(_:)), for: .touchUpInside)

        videoPlayer.addSubview(playButton!)

        //Slider
        let playbackSlider = UISlider(frame: CGRect(x: 10, y: 300, width: 300, height: 20))
        playbackSlider.frame = CGRect(x: (self.videoPlayer.bounds.width / 2) - 135,
                                      y: self.videoPlayer.bounds.height - 10,
                                      width: 300, height: 20)
        playbackSlider.minimumValue = 0

        if let itemDuration = videoPlayer.player?.currentItem?.duration {
            let seconds: Float64 = CMTimeGetSeconds(itemDuration)
            playbackSlider.maximumValue = Float(seconds)
        }

        playbackSlider.isContinuous = true
        playbackSlider.tintColor = UIColor.red

        playbackSlider.addTarget(self, action: #selector(self.playbackSliderValueChanged(_:)), for: .valueChanged)
        self.view.addSubview(playbackSlider)

        videoPlayer.player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 10000),
                                                    queue: .main, using: { (time) in
                                                        playbackSlider.value = Float(time.seconds)
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

    @objc func playButtonTapped(_ sender:UIButton) {
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

    @objc func playbackSliderValueChanged(_ playbackSlider:UISlider){

        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)

        videoPlayer.player?.seek(to: targetTime)

        if videoPlayer.player?.rate == 0 {
            videoPlayer?.play()
        }
    }
}
