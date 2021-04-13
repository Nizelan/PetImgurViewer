import UIKit

protocol AccountFavoritesDelegate: class {
    func playButtonPressed(post: FavoritePost)
}

class AccountFavorites: NSObject, UITableViewDelegate, UITableViewDataSource, AccFavoritesCellDelegate {
    var accFavorites: [FavoritePost]
    weak var delegate: AccountFavoritesDelegate?
    var tableView: UITableView

    init(favorites: [FavoritePost], tableView: UITableView, delegate: AccountFavoritesDelegate) {
        self.delegate = delegate
        self.tableView = tableView
        accFavorites = favorites
    }

    func playButtonPressed(cell: UITableViewCell) {
        guard let indexPathRow = tableView.indexPath(for: cell)?.row else {
            print("\(Self.self) now have cell")
            return
        }
        delegate?.playButtonPressed(post: accFavorites[indexPathRow])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accFavorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: "AccFavoritesCell", bundle: nil), forCellReuseIdentifier: "AccFavoritesCell")
        tableView.rowHeight = 400
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "AccFavoritesCell",
            for: indexPath) as? AccFavoritesCell else {
                return UITableViewCell()
        }
        cell.delegate = self
        cell.setup(with: accFavorites[indexPath.row])
        return cell
    }
}
