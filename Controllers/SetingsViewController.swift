//
//  SetingsViewController.swift
//  someAPIMadness
//
//  Created by Nizelan on 03.08.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit

protocol SetingsControllerDelegate: class {
    func update(sectionsText: String, sortText: String, windowText: String)
}

class SetingsViewController: UITableViewController {

    enum SectionButtons: String {
        case hot = "hot"
        case top = "top"
        case user = "user"
    }
    enum SortButtons: String {
        case viral = "viral"
        case top = "top"
        case time = "time"
        case rising = "rising"
    }
    enum WindowButtons: String {
        case week = "week"
        case month = "month"
        case year = "year"
        case all = "all"
    }
    
    var urlString = String()
    var sections = "hot"
    var sort = "top"
    var window = "viral"
    var button = String()
    
    weak var delegate: SetingsControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 664
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        delegate?.update(sectionsText: sections, sortText: sort, windowText: window)
    }
    
        // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SetingsCell", for: indexPath) as! SetingsCell
        
        return cell
    }
}
