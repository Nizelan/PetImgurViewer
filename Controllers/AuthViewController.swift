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

    @IBOutlet weak var titelLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var enterButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        authorization()
    }

    func update(dict: [String: String]) {
        AuthorizationData.authorizationData = dict
        print("TESTING_OUTPUT\(String(describing: AuthorizationData.authorizationData))")
    }

    @IBAction func login(_ sender: UIButton) {
        if AuthorizationData.authorizationData.isEmpty {
            performSegue(withIdentifier: "ShowWebView", sender: Any?.self)
        } else {
            performSegue(withIdentifier: "ShowAccount", sender: Any?.self)
        }
    }

    func authorization() {

        let urlString = "https://api.imgur.com/oauth2/authorize?client_id=960fe8e1862cf58&response_type=token"
        let httpHeaders = ["Authorization": "Client-ID 960fe8e1862cf58"]
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)

        urlRequest = request

        request.httpMethod = "GET"
        request.allHTTPHeaderFields = httpHeaders
                URLSession.shared.dataTask(with: request) { (data, response, error) in
           if let response = response {
               print(response)
           }
                    //print(String(data: data!, encoding: .utf8))
        }.resume()
    }

    func showAlert() {
        let alert = UIAlertController(title: "error", message: "Fields do not filled", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAccount" {
            guard segue.identifier == "ShowAccount" else { return }
            guard let destination = segue.destination as? AccountViewController else { return }
            destination.accountData = AuthorizationData.authorizationData
        } else if segue.identifier == "ShowWebView" {
            guard segue.identifier == "ShowWebView" else { return }
            guard let destination = segue.destination as? WebViewController else { return }
            destination.request = urlRequest
            destination.webDelegate = self
        }
    }
}
