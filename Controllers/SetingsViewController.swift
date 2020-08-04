//
//  SetingsViewController.swift
//  someAPIMadness
//
//  Created by Nizelan on 03.08.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 338
        urlString = "https://api.imgur.com/3/gallery/\(sections)/\(sort)/\(window)/1?showViral=true&mature=true&album_previews=true"
    }
    
    @IBAction func sectionsButtons(_ sender: UIButton) {
        button = sender.currentTitle!
        sections = button
        tableView.reloadData()
    }
    @IBAction func sortButtons(_ sender: UIButton) {
        button = sender.currentTitle!
        sort = button
        tableView.reloadData()
    }
    @IBAction func windowButtons(_ sender: UIButton) {
        button = sender.currentTitle!
        window = button
        tableView.reloadData()
    }
    
    
        // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SetingsCell", for: indexPath) as! SetingsCell
        
        cell.sectionsLable.text = sections
        cell.sortLable.text = sort
        cell.windowLable.text = window
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        urlString = "https://api.imgur.com/3/gallery/\(sections)/\(sort)/\(window)/1?showViral=true&mature=true&album_previews=true"
    }
}
