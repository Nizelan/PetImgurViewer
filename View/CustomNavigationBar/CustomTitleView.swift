//
//  CustomNavigationBar.swift
//  someAPIMadness
//
//  Created by Nizelan on 30.03.2021.
//  Copyright © 2021 Nizelan. All rights reserved.
//

import UIKit

protocol CustomTitleViewDelegate: class {
    func mostViralTapt()
    func follovingTapt()
}

class CustomTitleView: UIView {
    weak var delegate: CustomTitleViewDelegate?

    let sliderView = UIView()
    @IBOutlet var customTitle: UIView!
    @IBOutlet weak var mostViralBO: UIButton!
    @IBOutlet weak var followingBO: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        let bundle = Bundle(for: CustomTitleView.self)
        bundle.loadNibNamed("CustomTitleView", owner: self, options: nil)
        addSubview(customTitle)
        addSliderView()
        customTitle.frame = self.bounds
        customTitle.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    @IBAction func mostViral(_ sender: UIButton) {
        print("Most viral was tapped")
        animateSlide(point: mostViralBO.frame.origin.x)
        delegate?.mostViralTapt()
    }

    @IBAction func following(_ sender: UIButton) {
        print("Following was tapped")
        animateSlide(point: followingBO.frame.origin.x + 3)
        delegate?.follovingTapt()
    }

    func addSliderView() {
        sliderView.frame.size.width = mostViralBO.frame.size.width - 40
        sliderView.frame.size.height = 6
        sliderView.frame.origin.x = mostViralBO.frame.origin.x
        sliderView.frame.origin.y = mostViralBO.frame.origin.y + 38
        sliderView.backgroundColor = .white
        customTitle.addSubview(sliderView)
    }

    func animateSlide(point: CGFloat) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            var frame = self.sliderView.frame
            frame.origin.x = point
            frame.origin.y = self.mostViralBO.frame.origin.y + 38

            self.sliderView.frame = frame
        })
    }
}
