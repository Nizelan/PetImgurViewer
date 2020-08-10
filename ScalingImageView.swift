//
//  ScalingImageView.swift
//  someAPIMadness
//
//  Created by Roman Stasiv on 07.08.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import Foundation
import UIKit

class ScalingImageView: UIImageView {
    open var imageSize: CGSize? {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        if let size = imageSize {

            let scale = size.width / self.frame.width
            print("--- size (width: \(self.frame.width), height: \(size.height / scale)")
            return CGSize(width: self.frame.width, height: size.height / scale)
        }


        return super.intrinsicContentSize
    }
}
