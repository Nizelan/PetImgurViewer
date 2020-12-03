//
//  AcountFolloving.swift
//  someAPIMadness
//
//  Created by Nizelan on 28.11.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit

class AccountFollowing: NSObject, UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? AlbumCell else {
            return UITableViewCell()
        }
        return cell
    }
}
