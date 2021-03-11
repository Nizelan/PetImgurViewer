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
        NSLayoutConstraint.activate(
            [cell.viralImageView.widthAnchor.constraint(equalToConstant: (view.frame.width / 2) - 30),
             cell.viralImageView.heightAnchor.constraint(equalToConstant: 210)])

        if indexPath.row == (mostViralAlbums.count - 1) {
            page += 1
            fetchAlbums()
        }
        hideTabBar(index: indexPath.row)
        cell.setup(with: self.mostViralAlbums[indexPath.row]) { () -> Bool in
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

extension MostViralCollectionVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }

    func fetchAlbums() {
        networkManager.fetchGallery(sections: "top",
                                    sort: "viral",
                                    window: "week",
                                    page: page) {(galleryRasponse: GalleryResponse) in
            self.mostViralAlbums = galleryRasponse.data
            self.collectionView.reloadData()
        }
    }

    func hideTabBar(index: Int) {
        if self.index < index {
            self.index += 1
            tabBarController?.tabBar.isHidden = true
        } else if self.index > index {
            self.index -= 1
            tabBarController?.tabBar.isHidden = false
        }
    }
}
