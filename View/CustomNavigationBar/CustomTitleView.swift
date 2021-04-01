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
        customTitle.frame = self.bounds
        customTitle.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    @IBAction func mostViral(_ sender: UIButton) {
        print("Most viral be tapt")
        delegate?.mostViralTapt()
    }

    @IBAction func following(_ sender: UIButton) {
        print("Folloving be tapt")
        delegate?.follovingTapt()
    }
}
