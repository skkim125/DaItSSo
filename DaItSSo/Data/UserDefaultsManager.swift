//
//  UserDefaultsManager.swift
//  DaItSSo
//
//  Created by 김상규 on 6/14/24.
//

import Foundation

class UserDefaultsManager {
    
    private init() { }
    
    static let shared = UserDefaultsManager()
    let defaults = UserDefaults.standard
    
    enum Key: String, CaseIterable {
        case nickname, profile, editProfile, recentSearchArr, myShopping, isFirst
    }
    
    var nickname: String {
        get {
            return defaults.string(forKey: Key.nickname.rawValue) ?? ""
        }
        set {
            defaults.setValue(newValue, forKey: "\(Key.nickname.rawValue)")
        }
    }
    
    var profile: String {
        get {
            return defaults.string(forKey: Key.profile.rawValue) ?? ""
        }
        set {
            defaults.setValue(newValue, forKey: "\(Key.profile.rawValue)")
        }
    }
    
    var editProfile: String {
        get {
            return defaults.string(forKey: Key.editProfile.rawValue) ?? ""
        }
        set {
            defaults.setValue(newValue, forKey: "\(Key.editProfile.rawValue)")
        }
    }
    
    var recentSearchArr: [String] {
        get {
            return defaults.array(forKey: Key.recentSearchArr.rawValue)! as! [String]/* ?? [] as! [String]*/
        }
        set {
            defaults.setValue(newValue, forKey: "\(Key.recentSearchArr.rawValue)")
        }
    }
    
    var myShopping: [MyShopping] {
        get {
            return defaults.array(forKey: Key.myShopping.rawValue)! as! [MyShopping]
        }
        set {
            defaults.setValue(newValue, forKey: "\(Key.myShopping.rawValue)")
        }
    }
    
    var isStart: Bool {
        get {
            return defaults.bool(forKey: Key.isFirst.rawValue)
        }
        set {
            defaults.setValue(newValue, forKey: "\(Key.isFirst.rawValue)")
        }
    }
    
    func removeValue(keys: [Key]) {
        keys.forEach { key in
            defaults.removeObject(forKey: key.rawValue)
        }
    }
}
