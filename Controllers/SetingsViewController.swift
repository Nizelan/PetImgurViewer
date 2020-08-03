//
//  SetingsViewController.swift
//  someAPIMadness
//
//  Created by Nizelan on 03.08.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit

class SetingsViewController: UITableViewController {

    let setings = SetingsManager()
    var urlArray = [Character]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setings.stringToArray(string: "https://api.imgur.com/3/gallery/{{section}}/{{sort}}/{{window}}/1?showViral=true&mature=true&album_previews=true")
    }
    
    @IBAction func hotButton(_ sender: UIButton) {
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }


}
