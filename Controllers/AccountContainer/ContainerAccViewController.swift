import UIKit

class ContainerAccViewController: UIViewController, AccountViewControllerDelegate {
    func conect() {
        return
    }

    var accViewController = UIViewController()
    var accountPosts: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func configAccView() {
        if let viewController = UIStoryboard(
            name: "Main",
            bundle: nil).instantiateInitialViewController() as? AccountViewController {
            viewController.accDelegate = self
            accViewController = viewController
            addChild(accViewController)
            view.addSubview(accViewController.view)
            accViewController.didMove(toParent: self)
        }
    }

    func configPost() {
        if accountPosts == nil {
            self.accountPosts = AccountPosts()
            addChild(accountPosts)
            view.insertSubview(accountPosts.view, at: 0)
            accountPosts?.didMove(toParent: self)
        }
    }
}

extension ContainerAccViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
}
