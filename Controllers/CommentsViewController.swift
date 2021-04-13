import UIKit

class CommentsViewController: UITableViewController {
    let networkManager = NetworkManager()
    var albumID: String?
    var comments: [Comment] = []
    var countOfCells = Int()
    var indentationLevel = 0
    var currentIndent = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCell")

        if let albumID = albumID {
            self.networkManager.fetchComment(sort: "best", albumId: albumID) { (commentArray: GalleryCommentResponse) in
                self.comments = commentArray.data
                self.createCountOfCells(commentsArray: self.comments)
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countOfCells
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let commentCell =
            tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCell else {
                return UITableViewCell()
        }
        var dummy = 0
        var lvlOfIndent = 0
        if let comment = indentDetermine(at: indexPath.row, currentIndex: &dummy, indent: &lvlOfIndent, in: comments) {
            commentCell.setupCell(
                comment: comment,
                indentLVL: lvlOfIndent,
                urlString: comment.linkFinder()
            )
            self.currentIndent = 0

            return commentCell
        }
        return commentCell
    }

    func createCountOfCells(commentsArray: [Comment]) {
        for index in 0..<commentsArray.count {
            if let children = commentsArray[index].children {
                indentationLevel += 1
                countOfCells += 1
                createCountOfCells(commentsArray: children)
                indentationLevel -= 1
            } else {
                countOfCells += 1
            }
        }
    }

    func commentFind(at row: Int, currentIndex: inout Int, in array: [Comment]) -> Comment? {
        for comment in array {
            if currentIndex == row {
                return comment
            }
            currentIndex += 1
            if let children = comment.children {
                if comment.children?.isEmpty == true, let foundIt = commentFind(
                    at: row,
                    currentIndex: &currentIndex,
                    in: children
                    ) {
                    return foundIt
                }
            }
        }

        return nil
    }

    func indentDetermine(at row: Int, currentIndex: inout Int, indent: inout Int, in array: [Comment]) -> Comment? {
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
