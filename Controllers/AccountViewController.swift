//
//  AcountViewController.swift
//  someAPIMadness
//
//  Created by Nizelan on 25.11.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    var accountData: [String: String]?
    
    @IBOutlet weak var accountAvatar: UIImageView!
    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var pointsTrophy: UILabel!
    @IBOutlet weak var timeOfCreation: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
