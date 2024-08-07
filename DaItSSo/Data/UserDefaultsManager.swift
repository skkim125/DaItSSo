//
//  UserDefaultsManager.swift
//  DaItSSo
//
//  Created by 김상규 on 6/14/24.
//

import Foundation

final class UserDefaultsManager {
    
    private init() { }
    
    static let shared = UserDefaultsManager()
    let defaults = UserDefaults.standard
    
    enum Key: String, CaseIterable {
        case nickname, profile, recentSearchList, myShopping, isFirst, loginDate
    }
    
    var nickname: String {
        get {
            return defaults.string(forKey: Key.nickname.rawValue) ?? ""
        }
        set {
            defaults.setValue(newValue, forKey: Key.nickname.rawValue)
        }
    }
    
    var profile: String {
        get {
            return defaults.string(forKey: Key.profile.rawValue) ?? ""
        }
        set {
            defaults.setValue(newValue, forKey: Key.profile.rawValue)
        }
    }
    
    var recentSearchList: [String] {
        
        get {
            return defaults.array(forKey: Key.recentSearchList.rawValue) as? [String] ?? []
        }
        set {
            defaults.setValue(newValue, forKey: "\(Key.recentSearchList.rawValue)")
        }
    }
    
    var loginDate: String {
        get {
            return defaults.string(forKey: Key.loginDate.rawValue) ?? "정보 없음"
        }
        
        set {
            defaults.setValue(newValue, forKey: Key.loginDate.rawValue)
        }
    }
    
    var isStart: Bool {
        get {
            return defaults.bool(forKey: Key.isFirst.rawValue)
        }
        set {
            defaults.setValue(newValue, forKey: Key.isFirst.rawValue)
        }
    }
    
    func saveUserInfo(nickname: String, profile: String) {
        let userDefaults = UserDefaultsManager.shared
        userDefaults.isStart = true
        userDefaults.nickname = nickname
        userDefaults.profile = profile
        userDefaults.loginDate = DateFormatter.customDateFormatter(date: Date())
    }
    
    func removeValue(keys: [Key]) {
        keys.forEach { key in
            defaults.removeObject(forKey: key.rawValue)
        }
    }
}
