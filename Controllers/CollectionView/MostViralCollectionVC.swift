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

    private let networkService = NetworkService()

    var albums = [Post]()
    var selectedAlbum = 2
    var customTitle = CustomTitleView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.titleView = customTitle
        columnCountChange(columns: selectedAlbum)
        self.collectionView!.register(UINib(
            nibName: "MostViralCell", bundle: nil), forCellWithReuseIdentifier: "MostViralCell")
        fetchingDependingSelectedAlbum(selectedAlbum: .mostViral)
    }

    func scrollToRow(currentRow: Int) {
        let index = IndexPath(row: currentRow, section: 0)
        collectionView.scrollToItem(at: index, at: .bottom, animated: false)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "MostViralCell", for: indexPath) as? MostViralCell else {
            return UICollectionViewCell()
        }

        if indexPath.item == (albums.count - 3) {
            networkService.page += 1
            if selectedAlbum == 2 {
                fetchingDependingSelectedAlbum(selectedAlbum: .mostViral)
            } else if selectedAlbum == 1 {
                fetchingDependingSelectedAlbum(selectedAlbum: .following)
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
        fetchingDependingSelectedAlbum(selectedAlbum: .mostViral)
        collectionView.reloadData()
    }

    func follovingTapt() {
        albums.removeAll()
        selectedAlbum = 1
        columnCountChange(columns: selectedAlbum)
        fetchingDependingSelectedAlbum(selectedAlbum: .following)
        collectionView.reloadData()
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

    func fetchAlbums(sections: String, sort: String, window: String, album: Int) {
        networkService.networkManager.fetchGallery(sections: sections,
                                                   sort: sort,
                                                   window: window,
                                                   page: networkService.page) {(galleryRasponse: GalleryResponse) in
                                                    self.albums += galleryRasponse.data
                                                    self.collectionView.reloadData()
        }
    }

    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        if albums[indexPath.row].aspectRatio <= 0.2 {
            return 5000 * albums[indexPath.row].aspectRatio
        } else if albums[indexPath.row].aspectRatio <= 0.5 {
            return 1000 * albums[indexPath.row].aspectRatio
        } else {
            return 250 / albums[indexPath.row].aspectRatio
        }
    }

    func columnCountChange(columns: Int) {
        if let layout = collectionView?.collectionViewLayout as? CustomCollectionLayout {
            layout.delegate = self
            layout.numberOfColumns = columns
        }

        if let titleView = self.navigationController?.navigationBar.topItem?.titleView as? CustomTitleView {
            titleView.delegate = self
        }
    }

    func fetchingDependingSelectedAlbum(selectedAlbum: SelectedAlbum) {
        switch selectedAlbum {
        case .mostViral:
            fetchAlbums(sections: "top", sort: "viral", window: "week", album: self.selectedAlbum)
        case .following:
            fetchAlbums(sections: SettingsData.sectionsData,
                        sort: SettingsData.sortData,
                        window: SettingsData.windowData,
                        album: self.selectedAlbum)
        }
    }
}
