//
//  CollectionPostViewController.swift
//  someAPIMadness
//
//  Created by Nizelan on 05.12.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CollectionPostCell"

class CollectionPostView: UICollectionView {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
}
