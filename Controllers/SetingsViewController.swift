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

class SetingsViewController: UIViewController {
    
    var arrayOfSetings = [["hot", "top", "user"],
                          ["viral", "top", "time", "rising"],
                          ["week", "month", "year", "all"]]
    var selectedSeting: String?
    
    
    @IBOutlet weak var sectionsField: UITextField!
    @IBOutlet weak var sortField: UITextField!
    @IBOutlet weak var windowField: UITextField!
    
    weak var delegate: SetingsControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        choiceSeting()
        createToolbar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        delegate?.update(sectionsText: sectionsField.text!, sortText: sortField.text!, windowText: windowField.text!)
    }
    
    func choiceSeting() {
        let setingPicker = UIPickerView()
        setingPicker.delegate = self
        
        sectionsField.inputView = setingPicker
        sortField.inputView = setingPicker
        windowField.inputView = setingPicker
    }
    
    func createToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done",
                                         style: .plain,
                                         target: self,
                                         action: #selector(dismissKeyboard))
        toolbar.setItems([doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        
        sectionsField.inputAccessoryView = toolbar
        sortField.inputAccessoryView = toolbar
        windowField.inputAccessoryView = toolbar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension SetingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if sectionsField.isEditing == true {
            return arrayOfSetings[0].count
        } else if sortField.isEditing == true {
            return arrayOfSetings[1].count
        } else if windowField.isEditing == true {
            return arrayOfSetings[2].count
        }
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if sectionsField.isEditing == true {
            return arrayOfSetings[0][row]
        } else if sortField.isEditing == true {
            return arrayOfSetings[1][row]
        } else if windowField.isEditing == true {
            return arrayOfSetings[2][row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if sectionsField.isEditing == true {
            selectedSeting = arrayOfSetings[0][row]
            sectionsField.text = selectedSeting
        } else if sortField.isEditing == true {
            selectedSeting = arrayOfSetings[1][row]
            sortField.text = selectedSeting
        } else if windowField.isEditing == true {
            selectedSeting = arrayOfSetings[2][row]
            windowField.text = selectedSeting
        }
    }
}
