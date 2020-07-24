//
//  TableViewController.swift
//  someAPIMadness
//
//  Created by Nizelan on 14.07.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    let main = MainViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    func linksAsArray() -> [String] {
        
        var imageLinks = [String]()
        
        return imageLinks
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return main.arrayOfImages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        return cell
    }
}
