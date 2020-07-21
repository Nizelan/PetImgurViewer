//
//  MainViewController.swift
//  someAPIMadness
//
//  Created by Nizelan on 16.07.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var sectionOutlet: UITextField!
    @IBOutlet weak var sortOutlet: UITextField!
    @IBOutlet weak var windowOutlet: UITextField!
    @IBOutlet weak var numberOutlet: UITextField!
    
    let networkManager = NetworkManadger()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.fetchGallery()
    }

    @IBAction func downloadImageButton(_ sender: UIButton) {
    }
}
