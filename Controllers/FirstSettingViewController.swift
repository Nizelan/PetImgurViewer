//
//  SetingsViewController.swift
//  someAPIMadness
//
//  Created by Nizelan on 11.08.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit

protocol SettingsControllerDelegate: class {
    func update(sectionsText: String, sortText: String, windowText: String)
}

class FirstSettingViewController: UITableViewController, SettingViewControllerDelagate {

    var arrayOfSetings = [["hot", "top", "user"],
    ["viral", "top", "time", "rising"],
    ["week", "month", "year", "all"]]
    var settingsNames = [SettingsData.sectionsData, SettingsData.sortData, SettingsData.windowData]

    var selectedRow = 0
    var selectedSettings = [SettingsData.sectionsData, SettingsData.sortData, SettingsData.windowData]

    weak var delegate: SettingsControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        SettingsData.sectionsData = selectedSettings[0]
        SettingsData.sortData = selectedSettings[1]
        SettingsData.windowData = selectedSettings[2]
        delegate?.update(sectionsText: selectedSettings[0],
                         sortText: selectedSettings[1],
                         windowText: selectedSettings[2])
    }

    func updateSeting(selectedSetting: String) {
        self.selectedSettings[selectedRow] = selectedSetting
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)

        cell.textLabel?.text = settingsNames[indexPath.row]
        cell.detailTextLabel?.text = selectedSettings[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectCell = arrayOfSetings[indexPath.row]
        selectedRow = indexPath.row

        performSegue(withIdentifier: "SettingSegue", sender: selectCell)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SettingSegue" {
            guard let destination = segue.destination as? SecondSettingViewController else { return }
            guard let castedSender = sender as? [String] else { return }
            destination.settings = castedSender
            destination.settingDelegate = self
        }
    }
}
