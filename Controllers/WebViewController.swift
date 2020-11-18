//
//  WebViewController.swift
//  someAPIMadness
//
//  Created by Nizelan on 18.11.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    var request: URLRequest?

    override func viewDidLoad() {
        super.viewDidLoad()
        print(request)

        if let urlRequest = request {
            webView.load(urlRequest)
        }
    }
}
