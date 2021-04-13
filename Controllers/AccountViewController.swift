import UIKit

class AccountViewController: UIViewController,
SettingsControllerDelegate, AccountFavoritesDelegate, AccountPostDelegate {

    let networkManager = NetworkManager()
    var dataSource: (UITableViewDataSource & UITableViewDelegate)?
    var accountData: [String: String]?

    var accountImages: [AccPost] = []

    @IBOutlet weak var avatarActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var accountAvatar: UIImageView!
    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var pointsTrophy: UILabel!
    @IBOutlet weak var timeOfCreation: UILabel!
    @IBOutlet weak var tableViewSwitch: UISegmentedControl!
    @IBOutlet weak var accountTableView: UITableView!
    @IBOutlet weak var acountExitButton: UIButton!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        switchChosen()
        guard let userName = AuthorizationData.authorizationData["account_username"] else { return }
        accountName.text = userName
        fetchAcountBase()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.accountTableView.backgroundColor = .gray
        navigationController?.navigationBar.backItem?.hidesBackButton = true
        self.navigationItem.setHidesBackButton(true, animated: true)

        if accountData == nil {
            performSegue(withIdentifier: "ShowAuthVC", sender: Any?.self)
        }
    }

    func update(sectionsText: String, sortText: String, windowText: String) {
        SettingsData.sectionsData = sectionsText
        SettingsData.sortData = sortText
        SettingsData.windowData = windowText
    }

    @IBAction func goToSettings(_ sender: Any) {
    }

    @IBAction func exitButtonAction(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "UserAuthorizationData")
        AuthorizationData.authorizationData.removeAll()
        performSegue(withIdentifier: "ShowAuthVC", sender: Any?.self)
    }

    @IBAction func switchAction(_ sender: UISegmentedControl) {
        switchChosen()
    }

    func playButtonPressed(post: FavoritePost) {
        createVIdeoViewVC(link: post.images[0].mp4, title: post.title)
    }

    func playButtonPressed(post: AccPost) {
        createVIdeoViewVC(link: post.link, title: post.title)
    }

    func commentButtonPressed(post: AccPost) {
        guard let commentVC = storyboard?.instantiateViewController(
            identifier: "CommentVC") as? CommentsViewController else { return }
        commentVC.albumID = post.postId
        guard let albumId = commentVC.albumID else { return }
        commentVC.networkManager.fetchComment(
            sort: "best",
            albumId: albumId) { commentArray in
                commentVC.comments = commentArray.data
                commentVC.createCountOfCells(commentsArray: commentVC.comments)
                commentVC.tableView.reloadData()
        }
        self.present(commentVC, animated: true)
    }

    func fetchAcountBase() {
        guard let userName = AuthorizationData.authorizationData["account_username"] else { return }

        networkManager.fetchAcountBase(userName: userName) { accountBase in
            print(accountBase.data)
            self.startActivity()
            self.accountSetup(
                avatar: accountBase.data.avatar,
                name: accountBase.data.url,
                reputation: accountBase.data.reputation,
                creation: accountBase.data.created
            )
        }
    }

    func accountSetup(avatar: String, name: String, reputation: Int, creation: Int) {
        accountName.text = name
        avatarSetup(avatar: avatar)
        timeOfCreation.text = convertIntToDate(int: creation)
        pointsTrophy.text = String("Reputation \(reputation)")
    }

    func avatarSetup(avatar: String) {
        accountAvatar.layer.cornerRadius = 5
        accountAvatar.loadImage(from: avatar, completion: { success in
            if success {
                self.stopActivity()
            } else {
                self.stopActivity()
                self.accountAvatar.image = UIImage(named: "placeholder")
            }
        }, shouldAssignImage: nil)
    }

    func convertIntToDate(int: Int) -> String {
        let timeInterval = TimeInterval(int)
        let date = Date(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm E, d MMM y"
        return formatter.string(from: date)
    }

    func switchChosen() {
        guard let userName = AuthorizationData.authorizationData["account_username"] else { return }
        guard let accesToken = AuthorizationData.authorizationData["access_token"] else { return }

        if tableViewSwitch.selectedSegmentIndex == 0 {
            networkManager.fetchAccImage { (accGalleryResp: AccGalleryResp) in
                self.dataSource = AccountPosts(
                    images: accGalleryResp.data,
                    tableView: self.accountTableView,
                    delegate: self)
                self.setupTableView()
            }
        } else if tableViewSwitch.selectedSegmentIndex == 1 {
            networkManager.fetchAccFavorites(
                name: userName,
                accessToken: accesToken) { (accFavoritesResp: AccFavoritesResp) in
                    self.dataSource = AccountFavorites(
                        favorites: accFavoritesResp.data,
                        tableView: self.accountTableView,
                        delegate: self
                    )
                    self.setupTableView()
            }
        } else if tableViewSwitch.selectedSegmentIndex == 2 {
            self.accountTableView.reloadData()
        } else if tableViewSwitch.selectedSegmentIndex == 3 {
            networkManager.fetchAccComment(
                userName: userName,
                page: 0,
                sort: "newest"
            ) { (accCommentsResp: AccCommentsResp) in
                self.dataSource = AccountComments(comments: accCommentsResp.data, tableView: self.accountTableView)
                self.setupTableView()
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SetingsSegue" {
            guard let destination = segue.destination as? FirstSettingViewController else { return }
            destination.delegate = self
        }
    }
}

extension AccountViewController {

    func setupTableView() {
        self.accountTableView.delegate = self.dataSource
        self.accountTableView.dataSource = self.dataSource
        self.accountTableView.reloadData()
    }

    func createVIdeoViewVC(link: String?, title: String?) {
        guard let videoViewC = storyboard?.instantiateViewController(
            identifier: "VideoViewC") as? VideoViewController else { return }
        videoViewC.link = link
        videoViewC.name = title
        self.present(videoViewC, animated: true)
    }

    func startActivity() {
        avatarActivityIndicator.startAnimating()
        avatarActivityIndicator.isHidden = false
    }

    func stopActivity() {
        avatarActivityIndicator.stopAnimating()
        avatarActivityIndicator.isHidden = true
    }
}
