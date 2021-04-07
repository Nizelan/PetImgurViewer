//
//  MostViralCollectionVC.swift
//  someAPIMadness
//
//  Created by Nizelan on 10.03.2021.
//  Copyright © 2021 Nizelan. All rights reserved.
//

import UIKit

enum SelectedAlbum: Int {
    case mostViral = 2
    case following = 1
}

class MostViralCollectionVC: UICollectionViewController,
AlbumTableVCDelegate, CustomCollectionLayoutDelegate, CustomTitleViewDelegate {

    private let galleryService = GalleryService()

    var albums = [Post]()
    var selectedAlbum = 2
    var customTitle = CustomTitleView()
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.titleView = customTitle
        columnCountChange(columns: selectedAlbum)
        customTitle.delegate = self
        self.collectionView!.register(UINib(
            nibName: "MostViralCell",
            bundle: nil
        ), forCellWithReuseIdentifier: "MostViralCell")
        mostViralTapt()
    }

    func scrollToRow(currentRow: Int) {
        let index = IndexPath(row: currentRow, section: 0)
        collectionView.scrollToItem(at: index, at: .bottom, animated: false)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "MostViralCell", for: indexPath) as? MostViralCell else {
                return UICollectionViewCell()
        }

        if indexPath.item == (albums.count - 6) {
            galleryService.page += 1
            if selectedAlbum == 2 {
                galleryService.fetchGalleryAlbums(selectedAlbum: .mostViral) { (galleryResponse) in
                    self.albums += galleryResponse.data
                    self.collectionView.reloadData()
                }
                self.collectionView.reloadData()
            } else if selectedAlbum == 1 {
                galleryService.fetchGalleryAlbums(selectedAlbum: .following) { (galleryResponse) in
                    self.albums += galleryResponse.data
                    self.collectionView.reloadData()
                }
                self.collectionView.reloadData()
            }
        }
        cell.currentIndexPath = indexPath
        cell.setup(with: self.albums[indexPath.item]) { () -> Bool in
            return indexPath == cell.currentIndexPath
        }

        return cell
    }

    func mostViralTapt() {
        albums.removeAll()
        selectedAlbum = 2
        columnCountChange(columns: selectedAlbum)
        galleryService.fetchGalleryAlbums(selectedAlbum: .mostViral) { (galleryResponse) in
            self.albums += galleryResponse.data
            self.collectionView.reloadData()
        }
    }

    func follovingTapt() {
        albums.removeAll()
        selectedAlbum = 1
        columnCountChange(columns: selectedAlbum)
        galleryService.fetchGalleryAlbums(selectedAlbum: .following) { (galleryResponse) in
            self.albums += galleryResponse.data
            self.collectionView.reloadData()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedAlbum = indexPath.row
        performSegue(withIdentifier: "ShowAlbum", sender: Any?.self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAlbum" {
            guard let destination = segue.destination as? AlbumTableViewController else { return }
            destination.selectedAlbum = selectedAlbum
            destination.albums = albums
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

    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let cellWidth = collectionView.frame.width / 2 - 12
        let captionHeight = 49
        return cellWidth / albums[indexPath.row].aspectRatio + CGFloat(captionHeight)
    }

    func columnCountChange(columns: Int) {
        if let layout = collectionView?.collectionViewLayout as? CustomCollectionLayout {
            layout.delegate = self
            layout.numberOfColumns = columns
        }
    }
}
