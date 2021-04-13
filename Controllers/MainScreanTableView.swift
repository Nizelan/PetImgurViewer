import UIKit

protocol MainScreanTabelViewDelegate: class {
    func updateData()
    func didSelectRow(selectedAlbum: Int)
}

class MainScreanTableView: NSObject, UITableViewDelegate, UITableViewDataSource {

    weak var delegate: MainScreanTabelViewDelegate?
    var albums: [Post]
    var tableView: UITableView

    init(albums: [Post], tableView: UITableView, delegate: MainScreanTabelViewDelegate) {
        self.delegate = delegate
        self.albums = albums
        self.tableView = tableView
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        albums.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "FirstAlbumCell", bundle: nil), forCellReuseIdentifier: "FirstAlbumCell")
        guard let cell =
            tableView.dequeueReusableCell(withIdentifier: "FirstAlbumCell", for: indexPath) as? FirstAlbumCell else {
            return UITableViewCell()
        }

        if indexPath.row == (albums.count - 1) {
            delegate?.updateData()
        }

        cell.setup(with: albums[indexPath.row])
        tableView.sizeThatFits(albums[indexPath.row].coverSize)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectRow(selectedAlbum: indexPath.row)
    }

}
