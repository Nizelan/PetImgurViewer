//
//  WebViewController.swift
//  someAPIMadness
//
//  Created by Nizelan on 18.11.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit
import WebKit

protocol WebViewControllerDelegate: class {
    func update(dict: [String: String])
}
class WebViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var imgurWebView: WKWebView!
    var request: URLRequest?
    var testArray = [String]()
    var testDictionary = [String: String]()

    weak var webDelegate: WebViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let urlRequest = request {
            imgurWebView.load(urlRequest)
        }
        imgurWebView.navigationDelegate = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        webDelegate?.update(dict: testDictionary)
    }

    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
        print(navigationAction.request)
        if let uRLString = navigationAction.request.url?.absoluteString {
            if uRLString.contains("access_token") {
                testArray = uRLString.split(separator: "&").map({ (substring) -> String in
                    String(substring)
                })
                testArray[0].removeFirst(40)
                print("==============\(uRLString)")
                testDictionary = testArray.reduce(into: testDictionary) { (into, string) in
                    let callbackData = string.split(separator: "=").map { (substring) -> String in
                        String(substring)
                    }
                    into[callbackData[0]] = callbackData[1]
                }
            }
            print("-------------------------\(testDictionary)")
            print("&&&&&&&&&&&&&&&&&&\(testArray)")
        }
    }
}
