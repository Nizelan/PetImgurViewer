import UIKit

class AccountParent: UITableView {

    let parent = UITableViewController()
    let child = UITableViewController()
}

extension AccountParent {
    func add(_ child: UITableViewController) {
        add(child)
        addSubview(child.view)
        child.didMove(toParent: parent)
    }

    func remove() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }

        willMove(toSuperview: nil)
        child.removeFromParent()
    }
}
