//
//  AcountViewController.swift
//  someAPIMadness
//
//  Created by Nizelan on 25.11.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController, SettingsControllerDelegate, AccountFavoritesDelegate {

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

    override func viewDidLoad() {
        super.viewDidLoad()
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

    @IBAction func goToAlbums(_ sender: Any) {
    }

    @IBAction func switchAction(_ sender: UISegmentedControl) {
        switchChosen()
    }

    @IBAction func playPost(_ sender: UIButton) {
    }

    func playButtonPressed(post: FavoritePost) {
        let videoViewC = storyboard?.instantiateViewController(identifier: "VideoViewC") as? VideoViewController
        videoViewC?.link = post.images[0].mp4
        videoViewC?.name = post.title
        self.present(videoViewC!, animated: true)
    }

    func switchChosen() {
        guard let accName = AuthorizationData.authorizationData["account_username"] else { return }
        guard let accesToken = AuthorizationData.authorizationData["access_token"] else { return }

        if tableViewSwitch.selectedSegmentIndex == 0 {
            networkManager.fetchAccImage { (accGalleryResp: AccGalleryResp) in
                self.dataSource = AccountPosts(images: accGalleryResp.data)
                self.setupTableView()
            }
            print("AccountPosts")
        } else if tableViewSwitch.selectedSegmentIndex == 1 {
            networkManager.fetchAccFavorites(
                name: accName,
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
            networkManager.fetchAccComments(name: accName) { (accCommentsResp: AccCommentsResp) in
                self.dataSource = AccountComments(comments: accCommentsResp.data)
                self.setupTableView()
            }
            print("AccountComments")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SetingsSegue" {
            guard let destination = segue.destination as? SettingsViewController else { return }
            destination.delegate = self
        } else if segue.identifier == "ShowVideo" {
            guard let destination = segue.destination as? VideoViewController, let post = sender as? FavoritePost else { return }
            destination.name = post.title
            if let link = post.images[0].mp4 {
                destination.link = link
            }
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
