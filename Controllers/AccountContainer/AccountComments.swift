//
//  AcountComments.swift
//  someAPIMadness
//
//  Created by Nizelan on 28.11.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit

class AccountComments: NSObject, UITableViewDelegate, UITableViewDataSource {

    var accComments: [AccComment]

    init(comments: [AccComment]) {
        accComments = comments
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accComments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AccCommentsCell", for: indexPath) as? AccCommentsCell else {
            return UITableViewCell()
        }
        cell.accAuthorName.text = accComments[indexPath.row].author
        cell.accComment.text = accComments[indexPath.row].comment
        cell.accCommPts.text = String(accComments[indexPath.row].points)
        return cell
    }
}
