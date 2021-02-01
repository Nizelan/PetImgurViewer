//
//  AcountPosts.swift
//  someAPIMadness
//
//  Created by Nizelan on 28.11.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit

class AccountPosts: NSObject, UITableViewDelegate, UITableViewDataSource {

    let networkManager = NetworkManager()
    var accountImages: [AccPost]

    init(images: [AccPost]) {
        accountImages = images
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountImages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AccPostsCell", for: indexPath) as? AccPostsCell else {
            return UITableViewCell()
        }
        cell.setup(with: accountImages[indexPath.row])
        return cell
    }
}
