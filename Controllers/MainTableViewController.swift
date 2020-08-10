//
//  TableViewController.swift
//  someAPIMadness
//
//  Created by Nizelan on 14.07.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController, SetingsControllerDelegate {
    private let networkManager = NetworkManager()
    var sections = "hot"
    var sort = "top"
    var window = "viral"
    var albums = [Post]()
    var imagesCount = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        
        self.networkManager.fetchGallery(sections: sections, sort: sort, window: window) { (galleryArray: GalleryResponse) in
            
            self.albums = galleryArray.data
            self.tableView.reloadData()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? AlbumCell else {
            return UITableViewCell()
        }

        cell.setup(with: albums[indexPath.row])

        UIView.performWithoutAnimation {
            tableView.beginUpdates()
            tableView.endUpdates()
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAlbum = albums[indexPath.row]
        
        performSegue(withIdentifier: "AlbumSegue", sender: selectedAlbum)
    }

    func update(sectionsText: String, sortText: String, windowText: String) {
        sections = sectionsText
        sort = sortText
        window = windowText
    }

    @IBAction func goToSetings(_ sender: UIButton) {
        performSegue(withIdentifier: "SetingsSegue", sender: Any?.self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AlbumSegue" {
            guard let destination = segue.destination as? AlbumTableViewController else { return }
            guard let castedSender = sender as? Post else { return }
            destination.album = castedSender
        } else if segue.identifier == "SetingsSegue" {
            guard let destination = segue.destination as? SetingsViewController else { return }
            destination.delegate = self
        }
    }
}
