//
//  AcountViewController.swift
//  someAPIMadness
//
//  Created by Nizelan on 25.11.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController, SettingsControllerDelegate {

    let networkManager = NetworkManager()
    var dataSource: (UITableViewDataSource & UITableViewDelegate)?
    var accountData: [String: String]?

    var accountImages = [AccPost]()
    var link = String()
    var name = String()

    @IBOutlet weak var accountAvatar: UIImageView!
    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var pointsTrophy: UILabel!
    @IBOutlet weak var timeOfCreation: UILabel!
    @IBOutlet weak var tableViewSwitch: UISegmentedControl!
    @IBOutlet weak var accountTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
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

    @IBAction func goToVideo(_ sender: Any) {
    }

    func switchChosen() {
        guard let accName = AuthorizationData.authorizationData["account_username"] else { return }
        guard let accesToken = AuthorizationData.authorizationData["access_token"] else { return }
        if tableViewSwitch.selectedSegmentIndex == 0 {
            networkManager.fetchAccImage { (accGalleryResp: AccGalleryResp) in
                self.link = accGalleryResp.data[0].link
                if let name = accGalleryResp.data[0].title {
                    self.name = name
                } else {
                    self.name = ""
                }
                self.dataSource = AccountPosts(images: accGalleryResp.data)
                self.setupTableView()
            }
            print("AccountPosts")
        } else if tableViewSwitch.selectedSegmentIndex == 1 {
            networkManager.fetchAccFavorites(name: accName,
                                             accessToken: accesToken) { (accFavoritesResp: AccFavoritesResp) in
                                                if let link = accFavoritesResp.data[0].images[0].mp4 {
                                                    self.link = link
                                                }
                                                if let name = accFavoritesResp.data[0].title {
                                                    self.name = name
                                                }
                                                self.dataSource = AccountFavorites(favorites: accFavoritesResp.data)
                                                self.setupTableView()
            }
            print("AccountFavorites")
        } else if tableViewSwitch.selectedSegmentIndex == 2 {
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
        } else if segue.identifier == "PushFavorites" {
            guard let destination = segue.destination as? VideoViewController else { return }
            destination.link = link
            destination.name = name
        } else if segue.identifier == "PushPost" {
            guard let destination = segue.destination as? VideoViewController else { return }
            destination.name = name
            destination.link = link
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
