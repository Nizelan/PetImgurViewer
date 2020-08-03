//
//  SetingsModel.swift
//  someAPIMadness
//
//  Created by Nizelan on 03.08.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import Foundation

class SetingsManager {
    
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
    
    
    func manageSections(arrayURL: [Character], button: SectionButtons) {
        var openingBrakets = Int()
        var charakterArray = [Character]()
        var urlArray = arrayURL
        
        charakterArray = stringToArray(string: button.rawValue)
        
        for charakter in 0..<urlArray.count {
            
            if openingBrakets == 2 {
                if urlArray[charakter] != "{" && urlArray[charakter] != "}" {
                    urlArray.remove(at: charakter)
                    continue
                } else if urlArray[charakter] == "}" {
                    for i in 0..<charakterArray.count {
                        urlArray.insert(charakterArray[i], at: charakter - 1)
                    }
                    break
                }
            }
            if urlArray[charakter] == "{" {
                openingBrakets += 1
                continue
            }
        }
    }
    
    func manageSorting(arrayURL: [Character], button: SectionButtons) {
        var openingBrakets = Int()
        var charakterArray = [Character]()
        var urlArray = arrayURL
        
        charakterArray = stringToArray(string: button.rawValue)
        
        for charakter in 0..<urlArray.count {
            
            if openingBrakets == 2 {
                if urlArray[charakter] != "{" && urlArray[charakter] != "}" {
                    urlArray.remove(at: charakter)
                    continue
                } else if urlArray[charakter] == "}" {
                    for i in 0..<charakterArray.count {
                        urlArray.insert(charakterArray[i], at: charakter - 1)
                    }
                    break
                }
            }
            if urlArray[charakter] == "{" {
                openingBrakets += 1
                continue
            }
        }
    }
    
    func manageButtons(arrayURL: [Character], button: SectionButtons) {
        var openingBrakets = Int()
        var charakterArray = [Character]()
        var urlArray = arrayURL
        
        charakterArray = stringToArray(string: button.rawValue)
        
        for charakter in 0..<urlArray.count {
            
            if openingBrakets == 2 {
                if urlArray[charakter] != "{" && urlArray[charakter] != "}" {
                    urlArray.remove(at: charakter)
                    continue
                } else if urlArray[charakter] == "}" {
                    for i in 0..<charakterArray.count {
                        urlArray.insert(charakterArray[i], at: charakter - 1)
                    }
                    break
                }
            }
            if urlArray[charakter] == "{" {
                openingBrakets += 1
                continue
            }
        }
    }
    
    
    func stringToArray(string: String) -> [Character] {
        var array = [Character]()
        
        for _ in 0..<string.count {
            array.append(Character(String(string.dropFirst(1))))
        }
        return array
    }
}
