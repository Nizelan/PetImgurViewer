//
//  FavoritView.swift
//  someAPIMadness
//
//  Created by Nizelan on 28.11.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit

class AccountFavorites: NSObject, UITableViewDelegate, UITableViewDataSource {

    var accFavorites: [FavoritePost]

    init(favorites: [FavoritePost]) {
        accFavorites = favorites
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accFavorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AccFavoritesCell", for: indexPath) as? AccFavoritesCell else {
            return UITableViewCell()
        }
        cell.setup(with: accFavorites[indexPath.row])

        func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
            cell.favoritesVideo.player?.play()
        }
        return cell
    }
}