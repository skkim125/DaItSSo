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
        case nickname, profile, editProfile, recentSearchList, myShopping, isFirst, loginDate
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
    
    var editProfile: String {
        get {
            return defaults.string(forKey: Key.editProfile.rawValue) ?? ""
        }
        set {
            defaults.setValue(newValue, forKey: "\(Key.editProfile.rawValue)")
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
    
    var myShopping: [Item] {
        
        get {
            guard let data = defaults.data(forKey: Key.myShopping.rawValue) else {
                return []
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            do {
                let myShopping = try decoder.decode([Item].self, from: data)
                return myShopping
            } catch {
                print("Failed to decode myShopping: \(error)")
                return []
            }
        }
        
        set {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            
            do {
                let data = try encoder.encode(newValue)
                defaults.setValue(data, forKey: Key.myShopping.rawValue)
            } catch {
                print("Failed to encode myShopping: \(error)")
            }
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
    
    func removeValue(keys: [Key]) {
        keys.forEach { key in
            defaults.removeObject(forKey: key.rawValue)
        }
    }
}
