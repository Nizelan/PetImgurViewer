import UIKit

class AccountFollowing: NSObject, UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =
            tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SecongAlbumCell else {
            return UITableViewCell()
        }
        return cell
    }
}
