//
//  AuthViewController.swift
//  someAPIMadness
//
//  Created by Nizelan on 30.10.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController, WebViewControllerDelegate {

    private let networkManager = NetworkManager()
    var urlRequest: URLRequest?
    let clientID = ClientData.clientId
    let defaults = UserDefaults.standard
    let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                   FileManager.SearchPathDomainMask.allDomainsMask,
                                                   true)

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        if let unwraptDict = defaults.dictionary(forKey: "UserAuthorizationData") as? [String: String] {
            AuthorizationData.authorizationData = unwraptDict
            print(unwraptDict)
        }
        if AuthorizationData.authorizationData.isEmpty {
            let urlString = "https://api.imgur.com/oauth2/authorize?client_id=\(clientID)&response_type=token"
            guard let url = URL(string: urlString) else { return }
            let request = URLRequest(url: url)
            urlRequest = request
            performSegue(withIdentifier: "ShowWebView", sender: Any?.self)
        } else {
            guard let accessTokken = AuthorizationData.authorizationData["access_token"] else {
                print("\(Self.self) Access token is not be finded")
                return
            }
            networkManager.authorization(accessTokken: accessTokken)
            performSegue(withIdentifier: "ShowAccount", sender: Any?.self)
        }
    }

    func update(dict: [String: String]) {
        AuthorizationData.authorizationData = dict
        defaults.set(dict, forKey: "UserAuthorizationData")
        print("TESTING_OUTPUT\(String(describing: AuthorizationData.authorizationData))")
    }

    func showAlert() {
        let alert = UIAlertController(title: "error", message: "Fields do not filled", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAccount" {
            guard let destination = segue.destination as? AccountViewController else { return }
            destination.accountData = AuthorizationData.authorizationData
        } else if segue.identifier == "ShowWebView" {
            guard let destination = segue.destination as? WebViewController else { return }
            destination.request = urlRequest
            destination.webDelegate = self
        }
    }
}
