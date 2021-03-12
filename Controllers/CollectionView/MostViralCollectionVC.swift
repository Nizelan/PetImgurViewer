//
//  MostViralCollectionVC.swift
//  someAPIMadness
//
//  Created by Nizelan on 10.03.2021.
//  Copyright © 2021 Nizelan. All rights reserved.
//

import UIKit

class MostViralCollectionVC: UICollectionViewController, AlbumTableVCDelegate {

    private let networkManager = NetworkManager()

    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    private let itemsPerRow: CGFloat = 2

    var mostViralAlbums = [Post]()
    var selectedAlbum = 0
    var page = 1
    var index = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UINib(
            nibName: "MostViralCell", bundle: nil), forCellWithReuseIdentifier: "MostViralCell")
        fetchAlbums()
        if let layout = collectionView?.collectionViewLayout as? CustomCollectionLayout {
            layout.delegate = self
        }

        let swipeUP = UISwipeGestureRecognizer(target: self, action: #selector(hideTabBar))
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(hideTabBar))
        swipeUP.direction = .up
        swipeDown.direction = .down

        collectionView?.addGestureRecognizer(swipeUP)
        collectionView?.addGestureRecognizer(swipeDown)
    }

    func scrollToRow(currentRow: Int) {
        let index = IndexPath(row: currentRow, section: 0)
        collectionView.scrollToItem(at: index, at: .bottom, animated: false)
    }

    @objc func hideTabBar(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .up:
            tabBarController?.tabBar.isHidden = true
        case .down:
            tabBarController?.tabBar.isHidden = false
        default: break
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mostViralAlbums.count
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "MostViralCell", for: indexPath) as? MostViralCell else {
            return UICollectionViewCell()
        }

        if indexPath.item == (mostViralAlbums.count - 3) {
            page += 1
            fetchAlbums()
        }
        cell.setup(with: self.mostViralAlbums[indexPath.item]) { () -> Bool in
//            print(indexPath)
//            print(indexPath.row)
//            print(indexPath.item)
//            print(self.collectionView.indexPath(for: cell))
            return indexPath == self.collectionView.indexPath(for: cell)
        }

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedAlbum = indexPath.row

        performSegue(withIdentifier: "ShowAlbum", sender: Any?.self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAlbum" {
            guard let destination = segue.destination as? AlbumTableViewController else { return }
            destination.selectedAlbum = selectedAlbum
            destination.albums = mostViralAlbums
            destination.delegate = self
        }
    }
}

extension MostViralCollectionVC: UICollectionViewDelegateFlowLayout, CustomCollectionLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        guard let height = mostViralAlbums[indexPath.item].images?[0].height else { return 0}
        if height <= 250 {
            return CGFloat(height)
        } else if height > 250 {
            return 250
        }
       return CGFloat(height)
    }

    func fetchAlbums() {
        networkManager.fetchGallery(sections: "top",
                                    sort: "viral",
                                    window: "week",
                                    page: page) {(galleryRasponse: GalleryResponse) in
                                        self.mostViralAlbums += galleryRasponse.data
                                        self.collectionView.reloadData()
        }
    }
}
