//
//  CustomTabBarController.swift
//  someAPIMadness
//
//  Created by Nizelan on 11.03.2021.
//  Copyright © 2021 Nizelan. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    let appearance = UITabBarItem.appearance()
    let attributes = [NSAttributedString.Key.font: UIFont(name: "Arial", size: 35)]

    override func viewDidLoad() {
        super.viewDidLoad()
        appearance.setTitleTextAttributes(attributes as [NSAttributedString.Key: Any], for: .normal)

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.frame = CGRect(x: 0, y: 0, width: tabBar.frame.size.width, height: tabBar.frame.size.height)
    }
}
