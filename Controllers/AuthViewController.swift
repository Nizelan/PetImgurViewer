//
//  AuthViewController.swift
//  someAPIMadness
//
//  Created by Nizelan on 30.10.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    private let networkManager = NetworkManager()
    var urlRequest: URLRequest?

    var signup = true {
        willSet {
            if newValue {
                titelLabel.text = "Registration"
                nameField.isHidden = false
                enterButton.setTitle("Login", for: .normal)
            } else {
                titelLabel.text = "Login"
                nameField.isHidden = true
                enterButton.setTitle("Registraition", for: .normal)
            }
        }
    }

    @IBOutlet weak var titelLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var enterButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        nameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        authorization()
    }

    @IBAction func switchToLogin(_ sender: UIButton) {
        signup = !signup
    }

    func authorization() {

        let urlString = "https://api.imgur.com/oauth2/authorize?client_id=094e934ce523296&response_type=token"
        let httpHeaders = ["Authorization": "Client-ID 094e934ce523296"]
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)

        urlRequest = request

        request.httpMethod = "GET"
        request.allHTTPHeaderFields = httpHeaders
                URLSession.shared.dataTask(with: request) { (data, response, error) in
           if let response = response {
               print(response)
           }
                    print(String(data: data!, encoding: .utf8))
        }.resume()
    }

    func showAlert() {
        let alert = UIAlertController(title: "error", message: "Fields do not filled", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowWebView" else { return }
        guard let destination = segue.destination as? WebViewController else { return }
        destination.request = urlRequest
    }
}

    // MARK: Extentions
extension AuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let name = nameField.text
        let email = emailField.text
        let password = passwordField.text

        if signup {
            if name!.isEmpty || email!.isEmpty || password!.isEmpty {
                showAlert()
            } else {
                print("Fields is not empty")
            }
        } else {
            if email!.isEmpty || password!.isEmpty {
                showAlert()
            } else {
                performSegue(withIdentifier: "ShowWebView", sender: Any?.self)
            }
        }
        return true
    }
}
