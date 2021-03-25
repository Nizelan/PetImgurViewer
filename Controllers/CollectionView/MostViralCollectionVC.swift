//
//  MostViralCollectionVC.swift
//  someAPIMadness
//
//  Created by Nizelan on 10.03.2021.
//  Copyright © 2021 Nizelan. All rights reserved.
//

import UIKit

class MostViralCollectionVC: UICollectionViewController, AlbumTableVCDelegate, CustomCollectionLayoutDelegate {

    private let networkService = NetworkService()

    var mostViralAlbums = [Post]()
    var customAlbum = [Post]()
    var selectedAlbum = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        columnCountChange(columns: 2)
        self.collectionView!.register(UINib(
            nibName: "MostViralCell", bundle: nil), forCellWithReuseIdentifier: "MostViralCell")
        fetchAlbums(sections: "top", sort: "viral", window: "week", album: 1)
    }

    func scrollToRow(currentRow: Int) {
        let index = IndexPath(row: currentRow, section: 0)
        collectionView.scrollToItem(at: index, at: .bottom, animated: false)
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
            networkService.page += 1
            fetchAlbums(sections: "top", sort: "viral", window: "week", album: 1)
        }
        cell.currentIndexPath = indexPath
        cell.setup(with: self.mostViralAlbums[indexPath.item]) { () -> Bool in
            return indexPath == cell.currentIndexPath
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

    override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let actualPosition = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if actualPosition.y > 0 {
            tabBarController?.tabBar.isHidden = false
        } else {
            tabBarController?.tabBar.isHidden = true
        }
    }

    func fetchAlbums(sections: String, sort: String, window: String, album: Int) {
        networkService.networkManager.fetchGallery(sections: sections,
                                    sort: sort,
                                    window: window,
                                    page: networkService.page) {(galleryRasponse: GalleryResponse) in
                                        if album == 1 {
                                            self.mostViralAlbums += galleryRasponse.data
                                            self.collectionView.reloadData()
                                        } else if album == 0 {
                                            self.customAlbum += galleryRasponse.data
                                            self.collectionView.reloadData()
                                        }
        }
    }

    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        if mostViralAlbums[indexPath.row].aspectRatio <= 0.2 {
            return 5000 * mostViralAlbums[indexPath.row].aspectRatio
        } else if mostViralAlbums[indexPath.row].aspectRatio <= 0.5 {
            return 1000 * mostViralAlbums[indexPath.row].aspectRatio
        } else {
            return 250 / mostViralAlbums[indexPath.row].aspectRatio
        }
    }

    func columnCountChange(columns: Int) {
        if let layout = collectionView?.collectionViewLayout as? CustomCollectionLayout {
            layout.delegate = self
            layout.numberOfColumns = columns
        }
    }
}
