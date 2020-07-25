//
//  SecondViewController.swift
//  someAPIMadness
//
//  Created by Nizelan on 25.07.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    let tableDelegate = TableViewController()
    
    var imageURL: URL?
    var image: UIImage? {
        get {
            imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImage()
    }
    
    func fetchImage() {
        imageURL = URL(string: "https://i.imgur.com/hgSsQ3t.jpg")
        guard let url = imageURL, let imageData = try? Data(contentsOf: url) else { return }
        self.image = UIImage(data: imageData)
    }
}
