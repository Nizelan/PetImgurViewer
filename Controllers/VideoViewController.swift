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
    @IBOutlet weak var imageViewOutlet: ScalingImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var playVideoButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupImage(with: link)
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
        playVideo()
    }

    func setupTitle(title: String?) {
        if name == nil {
            titleLable.isHidden = true
        } else {
            titleLable.text = name
        }
    }

    func setupImage(with link: String?) {
        guard let imageLink = link else { return }

        if imageLink.contains("mp4") {
            playVideoButton.isHidden = false
            imageViewOutlet.image = UIImage(named: "placeholder")
            stopActivity()
        } else {
            playVideoButton.isHidden = true
            self.startActivity()
            imageViewOutlet.loadImage(from: imageLink, completion: { (success) in
                self.stopActivity()
                if success {
                    print("successfully loaded image with url: \(imageLink)")
                } else {
                    print("failed to load image with url: \(imageLink)")
                }
            })
        }
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
