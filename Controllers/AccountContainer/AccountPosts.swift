//
//  AcountPosts.swift
//  someAPIMadness
//
//  Created by Nizelan on 28.11.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit

protocol AccountPostDelegate: class {
    func playButtonPressed(post: AccPost)
    func commentButtonPressed(post: AccPost)
}

class AccountPosts: NSObject, UITableViewDelegate, UITableViewDataSource, AccPostCellDelegate {

    weak var delegate: AccountPostDelegate?
    var accountImages: [AccPost]
    var tableView: UITableView

    init(images: [AccPost], tableView: UITableView, delegate: AccountPostDelegate) {
        self.delegate = delegate
        self.tableView = tableView
        accountImages = images
    }

    func playButtonPrassed(cell: UITableViewCell) {
        guard let indexPathRow = tableView.indexPath(for: cell)?.row else {
            print("\(Self.self) now have cell")
            return
        }
        delegate?.playButtonPressed(post: accountImages[indexPathRow])
    }

    func commentButtomPrassed(cell: UITableViewCell) {
        guard let indexPathRow = tableView.indexPath(for: cell)?.row else {
            print("\(Self.self) now have cell")
            return
        }
        delegate?.commentButtonPressed(post: accountImages[indexPathRow])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountImages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: "AccPostCell", bundle: nil), forCellReuseIdentifier: "AccPostCell")
        guard let cell =
            tableView.dequeueReusableCell(withIdentifier: "AccPostCell", for: indexPath) as? AccPostCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.setup(with: accountImages[indexPath.row])
        return cell
    }
}
