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
    var tableView: UITableView
    var indentationLevel = 0
    var currentIndent = 0

    init(comments: [AccComment], tableView: UITableView) {
        accComments = comments
        self.tableView = tableView
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accComments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: "AccCommentsCell", bundle: nil), forCellReuseIdentifier: "AccCommentsCell")
        tableView.rowHeight = UITableView.automaticDimension
        guard let cell =
            tableView.dequeueReusableCell(withIdentifier: "AccCommentsCell", for: indexPath) as? AccCommentsCell else {
                return UITableViewCell()
        }

        var dummy = 0
        var lvlOfIndent = 0
        if let comment = indentDetermine(
            at: indexPath.row,
            currentIndex: &dummy,
            indent: &lvlOfIndent,
            in: accComments
            ) {
            cell.setup(comment: comment, indentLVL: lvlOfIndent)
            self.currentIndent = 0

            return cell
        }
        return cell
    }

    func indentDetermine(
        at row: Int,
        currentIndex: inout Int,
        indent: inout Int,
        in array: [AccComment]
    ) -> AccComment? {
        for comment in array {
            if currentIndex == row {
                return comment
            }
            currentIndex += 1
            if let children = comment.children {
                if comment.children?.isEmpty == true, let foundIt = indentDetermine(
                    at: row,
                    currentIndex: &currentIndex,
                    indent: &indent,
                    in: children
                    ) {
                    indent += 1
                    self.currentIndent = indent
                    return foundIt
                }
            }
        }
        return nil
    }
}
