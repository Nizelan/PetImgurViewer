//
//  TableView.swift
//  someAPIMadness
//
//  Created by Nizelan on 12.10.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit

class TableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var commentsArray: CommentInfo
    
    init(comments: CommentInfo) {
        commentsArray = comments
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
}
