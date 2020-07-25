//
//  TableViewController.swift
//  someAPIMadness
//
//  Created by Nizelan on 14.07.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    
    let albumCell = AlbumCell()
    let networkManager = NetworkManadger()
    var albums = [GalleryEntry]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkManager.fetchGallery { (galleryArray: GalleryResponse) in
        
            self.albums = galleryArray.data
            print(self.albums)
            self.tableView.reloadData()
        }
        
    }
    
    @IBAction func button(_ sender: UIButton) {
        
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return albums.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        return cell
    }
}
