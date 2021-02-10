//
//  SettingViewController.swift
//  someAPIMadness
//
//  Created by Nizelan on 11.08.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit

protocol SettingViewControllerDelagate: class {
    func updateSeting(selectedSetting: String)
}

class SecondSettingViewController: UITableViewController {

    var settings = [String]()
    var selectedString = ""
    weak var settingDelegate: SettingViewControllerDelagate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        settingDelegate?.updateSeting(selectedSetting: selectedString)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return settings.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)

        cell.textLabel?.text = settings[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedString = settings[indexPath.row]
    }
}
