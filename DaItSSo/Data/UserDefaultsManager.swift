//
//  UserDefaultsManager.swift
//  DaItSSo
//
//  Created by 김상규 on 6/14/24.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    let userdefaults = UserDefaults.standard
    
    func saveNickname(nickname: String) {
        userdefaults.setValue(nickname, forKey: "nickname")
    }
    
    func saveProfile(profile: String) {
        userdefaults.setValue(profile, forKey: "profile")
    }
    
    func saveRecentSearch(array: [String]) {
        userdefaults.setValue(array, forKey: "recentSearchArr")
    }
    
    func isFirst(bool: Bool) {
        userdefaults.setValue(bool, forKey: "first")
    }
}
