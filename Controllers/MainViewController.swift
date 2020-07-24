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
    var arrayOfImages = [GalleryResponse]()
    var imageLinks = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.fetchGallery { (galleryArray: GalleryResponse) in
            print(galleryArray)
            self.arrayOfImages = [galleryArray]
            for i in 0...self.arrayOfImages.count {
                self.imageLinks.append(galleryArray.data[i].images[i].link)
            }
            
            
        }
    }
    

    @IBAction func downloadImageButton(_ sender: UIButton) {
        print(self.imageLinks)
    }
}
