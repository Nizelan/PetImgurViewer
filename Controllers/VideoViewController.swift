import UIKit
import AVKit
import AVFoundation

class VideoViewController: UIViewController {

    var name: String?
    var link: String?
    var isFirst = true

    var titleLable = UILabel()
    @IBOutlet weak var videoPlayer: CustomVideoPlayer!
    var volumeSlider = UISlider()
    var playButton = UIButton()
    var videoProgresSlider = UISlider()
    var controlsBar = UIView()
    let blur = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    var tap = UITapGestureRecognizer()
    var timer = Timer()
    var muteUnmuteButton = UIButton()
    var timeGone = UILabel()
    var timeLeft = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        videoPlayer.videoLink = link
        setupTitle(title: name)

        tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        videoPlayer.addGestureRecognizer(tap)

        timeGone.frame.size.width = 80
        timeLeft.frame.size.width = 80
        titleLable.backgroundColor = .gray
        titleLable.alpha = 0.7
        videoPlayer.addSubview(titleLable)
        controlsBar.addSubview(timeLeft)
        controlsBar.addSubview(timeGone)

        blur.layer.masksToBounds = true
        blur.layer.cornerRadius = 10
        videoPlayer.addSubview(blur)
        videoPlayer.addSubview(controlsBar)

        muteUnmuteButton.frame.size = CGSize(width: 30, height: 30)
        muteUnmuteButton.backgroundColor = .none
        muteUnmuteButton.setImage(UIImage(named: "unmute"), for: .normal)
        muteUnmuteButton.addTarget(self, action: #selector(self.muteUnmuteAction(_:)), for: .touchUpInside)
        controlsBar.addSubview(muteUnmuteButton)

        playButton.frame.size = CGSize(width: 50, height: 50)
        playButton.backgroundColor = .none
        playButton.setImage(UIImage(named: "PlayButton"), for: .normal)
        playButton.addTarget(self, action: #selector(self.playPauseButtonAction(_:)), for: .touchUpInside)
        controlsBar.addSubview(playButton)

        videoProgresSlider.minimumValue = 0
        if let itemDuration = videoPlayer.player?.currentItem?.duration {
            let seconds: Float64 = CMTimeGetSeconds(itemDuration)
            videoProgresSlider.maximumValue = Float(seconds)
        }
        videoProgresSlider.setThumbImage(UIImage(named: "slider"), for: .normal)
        videoProgresSlider.isContinuous = true
        videoProgresSlider.tintColor = .black
        videoProgresSlider.addTarget(self, action: #selector(self.videoProgresSliderAction(_:)), for: .valueChanged)
        controlsBar.addSubview(videoProgresSlider)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupConstraints()
        setupBlurConstraints()
        var lineFixer = String()
        videoPlayer.player?.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 1, preferredTimescale: 10000),
            queue: .main) { time in
                lineFixer =
                    Double(self.videoProgresSlider.maximumValue - Float(time.seconds)).asString(style: .positional)
                if Float(time.seconds) < 10 {
                    self.timeGone.text = "00:0\(Double(time.seconds).asString(style: .positional))"
                } else {
                    self.timeGone.text = "00:\(Double(time.seconds).asString(style: .positional))"
                }

                if self.videoProgresSlider.maximumValue - Float(time.seconds) < 10 {
                    self.timeLeft.text = "00:0\(lineFixer)"
                } else {
                    self.timeLeft.text = "00:\(lineFixer)"
                }
                self.videoProgresSlider.value = Float(time.seconds)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        videoPlayer.pause()
        super.viewWillDisappear(true)
    }

    @IBAction func playPauseButtonAction(_ sender: Any) {
        setControllsVisibl()
        if videoProgresSlider.value == videoProgresSlider.maximumValue {
            videoPlayer.player?.seek(to: CMTime(seconds: 0, preferredTimescale: 1000))
        }

        if videoPlayer.player?.timeControlStatus == .playing {
            playButton.setImage(UIImage(named: "PlayButton"), for: .normal)
            videoPlayer.pause()
        } else {
            playButton.setImage(UIImage(named: "PauseButton"), for: .normal)
            videoPlayer.play()
            if isFirst {
                setupProgressVideoSlider()
            }
        }
        setControllsUnseen()
    }

    @IBAction func muteUnmuteAction(_ sender: Any) {
        setControllsVisibl()
        if videoPlayer.player?.volume == 0 {
            videoPlayer.player?.volume = 5
            muteUnmuteButton.setImage(UIImage(named: "unmute"), for: .normal)
        } else {
            videoPlayer.player?.volume = 0
            muteUnmuteButton.setImage(UIImage(named: "mute"), for: .normal)
        }
        setControllsUnseen()
    }

    @IBAction func videoProgresSliderAction(_ sender: Any) {
        setControllsVisibl()
        videoPlayer.player?.seek(to: CMTime(seconds: Double(videoProgresSlider.value), preferredTimescale: 1000))
        setControllsUnseen()
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

    private func setupBlurConstraints() {
        blur.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blur.topAnchor.constraint(equalTo: controlsBar.topAnchor),
            blur.bottomAnchor.constraint(equalTo: controlsBar.bottomAnchor),
            blur.leadingAnchor.constraint(equalTo: controlsBar.leadingAnchor),
            blur.trailingAnchor.constraint(equalTo: controlsBar.trailingAnchor)
        ])
    }

    private func setupConstraints() {
        videoPlayer.translatesAutoresizingMaskIntoConstraints = false
        playButton.translatesAutoresizingMaskIntoConstraints = false
        videoProgresSlider.translatesAutoresizingMaskIntoConstraints = false
        controlsBar.translatesAutoresizingMaskIntoConstraints = false
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        muteUnmuteButton.translatesAutoresizingMaskIntoConstraints = false
        timeGone.translatesAutoresizingMaskIntoConstraints = false
        timeLeft.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            videoPlayer.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            videoPlayer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            videoPlayer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            videoPlayer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),

            titleLable.heightAnchor.constraint(equalToConstant: 21),
            titleLable.topAnchor.constraint(equalTo: videoPlayer.topAnchor, constant: 8),
            titleLable.leadingAnchor.constraint(equalTo: videoPlayer.leadingAnchor, constant: 8),
            titleLable.trailingAnchor.constraint(equalTo: videoPlayer.trailingAnchor, constant: -8),

            controlsBar.heightAnchor.constraint(equalToConstant: 100),
            controlsBar.leadingAnchor.constraint(equalTo: videoPlayer.leadingAnchor, constant: 20),
            controlsBar.trailingAnchor.constraint(equalTo: videoPlayer.trailingAnchor, constant: -20),
            controlsBar.bottomAnchor.constraint(equalTo: videoPlayer.bottomAnchor, constant: -20),

            muteUnmuteButton.heightAnchor.constraint(equalToConstant: 30),
            muteUnmuteButton.widthAnchor.constraint(equalToConstant: 30),
            muteUnmuteButton.leadingAnchor.constraint(equalTo: controlsBar.leadingAnchor, constant: 20),
            muteUnmuteButton.bottomAnchor.constraint(equalTo: controlsBar.bottomAnchor, constant: -17),
            playButton.centerXAnchor.constraint(equalTo: controlsBar.centerXAnchor),
            playButton.bottomAnchor.constraint(equalTo: controlsBar.bottomAnchor, constant: -20),

            timeGone.centerYAnchor.constraint(equalTo: videoProgresSlider.centerYAnchor),
            timeGone.trailingAnchor.constraint(equalTo: videoProgresSlider.leadingAnchor, constant: -8),
            timeLeft.centerYAnchor.constraint(equalTo: videoProgresSlider.centerYAnchor),
            timeLeft.leadingAnchor.constraint(equalTo: videoProgresSlider.trailingAnchor, constant: 8),

            videoProgresSlider.heightAnchor.constraint(equalToConstant: 33),
            videoProgresSlider.widthAnchor.constraint(equalToConstant: 250),
            videoProgresSlider.bottomAnchor.constraint(equalTo: playButton.topAnchor, constant: -8),
            videoProgresSlider.centerXAnchor.constraint(equalTo: controlsBar.centerXAnchor)
        ])
    }

    func setupProgressVideoSlider() {
        guard let duration = self.videoPlayer.player?.currentItem?.asset.duration.seconds else {
            print("\(Self.self) error: now have Current Item duration time")
            return
        }
        self.videoProgresSlider.maximumValue = Float(duration)
    }

    @objc func tapHandler() {
        setControllsVisibl()
        setControllsUnseen()
    }

    func setControllsVisibl() {
        self.controlsBar.isHidden = false
        self.blur.isHidden = false
        timer.invalidate()
    }

    func setControllsUnseen() {
        timer = .scheduledTimer(withTimeInterval: 5.0, repeats: false) { _ in
            self.controlsBar.isHidden = true
            self.blur.isHidden = true
        }
    }
}

extension Double {
    func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = style
        guard let formattedString = formatter.string(from: self) else { return "" }
        return formattedString
    }
}
