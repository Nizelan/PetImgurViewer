//
//  AcountViewController.swift
//  someAPIMadness
//
//  Created by Nizelan on 25.11.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController,
SettingsControllerDelegate, AccountFavoritesDelegate, AccountPostDelegate {

    let networkManager = NetworkManager()
    var dataSource: (UITableViewDataSource & UITableViewDelegate)?
    var accountData: [String: String]?

    var accountImages = [AccPost]()

    @IBOutlet weak var accountAvatar: UIImageView!
    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var pointsTrophy: UILabel!
    @IBOutlet weak var timeOfCreation: UILabel!
    @IBOutlet weak var tableViewSwitch: UISegmentedControl!
    @IBOutlet weak var accountTableView: UITableView!
    @IBOutlet weak var acountExitButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        if accountData == nil {
            performSegue(withIdentifier: "ShowAuthVC", sender: Any?.self)
        }

        navigationController?.navigationBar.backItem?.hidesBackButton = true
        self.navigationItem.setHidesBackButton(true, animated: true)
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
        let videoViewC = storyboard?.instantiateViewController(identifier: "VideoViewC") as? VideoViewController
        videoViewC?.link = post.images[0].mp4
        videoViewC?.name = post.title
        self.present(videoViewC!, animated: true)
    }

    func playButtonPressed(post: AccPost) {
        let videoViewC = storyboard?.instantiateViewController(identifier: "VideoViewC") as? VideoViewController
        videoViewC?.link = post.link
        videoViewC?.name = post.title
        self.present(videoViewC!, animated: true)
    }

    func commentButtonPressed(post: AccPost) {
        let commentVC = storyboard?.instantiateViewController(identifier: "CommentVC") as? CommentsViewController
        commentVC?.albumID = post.postId
        commentVC?.networkManager.fetchComment(sort: "best",
                                               albumId: commentVC!.albumID!,
                                               closure: { (commentArray: GalleryCommentResponse) in
            commentVC?.comments = commentArray.data
            commentVC?.createCountOfCells(commentsArray: commentVC!.comments)
            commentVC?.tableView.reloadData()
        })
        self.present(commentVC!, animated: true)
    }

    func switchChosen() {
        guard let userName = AuthorizationData.authorizationData["account_username"] else { return }
        guard let accesToken = AuthorizationData.authorizationData["access_token"] else { return }

        if tableViewSwitch.selectedSegmentIndex == 0 {
            networkManager.fetchAccImage { (accGalleryResp: AccGalleryResp) in
                self.dataSource = AccountPosts(images: accGalleryResp.data,
                                               tableView: self.accountTableView,
                                               delegate: self)
                self.setupTableView()
            }
            print("AccountPosts")
        } else if tableViewSwitch.selectedSegmentIndex == 1 {
            networkManager.fetchAccFavorites(
                name: userName,
                accessToken: accesToken) { (accFavoritesResp: AccFavoritesResp) in
                    self.dataSource = AccountFavorites(favorites: accFavoritesResp.data,
                                                       tableView: self.accountTableView,
                                                       delegate: self)
                    self.setupTableView()
            }
            print("AccountFavorites")
        } else if tableViewSwitch.selectedSegmentIndex == 2 {
            self.accountTableView.reloadData()
            print("AccountFollowing")
        } else if tableViewSwitch.selectedSegmentIndex == 3 {
            networkManager.fetchAccComment(userName: userName,
                                           page: 0,
                                           sort: "newest") { (accCommentsResp: AccCommentsResp) in
                self.dataSource = AccountComments(comments: accCommentsResp.data, tableView: self.accountTableView)
                self.setupTableView()
            }
            print("AccountComments")
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
}
