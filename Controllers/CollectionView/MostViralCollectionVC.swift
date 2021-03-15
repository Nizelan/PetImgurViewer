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

    override func viewDidLoad() {
        super.viewDidLoad()
        if let layout = collectionView?.collectionViewLayout as? CustomCollectionLayout {
            layout.delegate = self
        }
        self.collectionView!.register(UINib(
            nibName: "MostViralCell", bundle: nil), forCellWithReuseIdentifier: "MostViralCell")
        fetchAlbums()
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
            networkManager.page += 1
            fetchAlbums()
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
}

extension MostViralCollectionVC: CustomCollectionLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        if mostViralAlbums[indexPath.row].aspectRatio <= 0.2 {
            return 5000 * mostViralAlbums[indexPath.row].aspectRatio
        } else if mostViralAlbums[indexPath.row].aspectRatio <= 0.5 {
            return 1000 * mostViralAlbums[indexPath.row].aspectRatio
        } else {
            return 250 / mostViralAlbums[indexPath.row].aspectRatio
        }
    }

    func fetchAlbums() {
        networkManager.fetchGallery(sections: "top",
                                    sort: "viral",
                                    window: "week",
                                    page: networkManager.page) {(galleryRasponse: GalleryResponse) in
                                        self.mostViralAlbums += galleryRasponse.data
                                        self.collectionView.reloadData()
        }
    }
}
