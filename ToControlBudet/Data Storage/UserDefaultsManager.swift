//
//  UserDefaults.swift
//  ToControlBudet
//
//  Created by Арсен Хачатрян on 08.12.2023.
//

import Foundation

import Foundation

protocol UserDefaultsManagerProtocol{
    
    func set(_ object:Any?, forKey key: UserDefaultsManager.Keys)
    func string(forKey key:UserDefaultsManager.Keys) -> String?
    func double(forKey key: UserDefaultsManager.Keys) -> Double?
    func remove(forKey key: UserDefaultsManager.Keys)
    func bool(forKey key: UserDefaultsManager.Keys) -> Bool?
    func integer(forKey key: UserDefaultsManager.Keys) -> Int?
}

final class UserDefaultsManager{
    
    static let shared = UserDefaultsManager()
    
    private init() {}
    
    public enum Keys: String {
        
        case budget
        case currency
        case numOfCurrency
        case coefficient
        
    }
    
    private let userDefaults = UserDefaults.standard
    
    private func store(_ object:Any?, key: String){
        
        userDefaults.set(object, forKey: key)
        
    }
    
    private func restore(forKey key:String) -> Any?{
        
        userDefaults.object(forKey: key)
        
    }
    
}

extension UserDefaultsManager: UserDefaultsManagerProtocol {
    
    func set(_ object: Any?, forKey key: Keys) {
        store(object, key: key.rawValue)
    }
    
    func string(forKey key: Keys) -> String? {
        restore(forKey: key.rawValue) as? String
    }
    
    func bool(forKey key: Keys) -> Bool? {
        
        restore(forKey: key.rawValue) as? Bool
        
    }
    
    func double(forKey key: Keys) -> Double? {
        restore(forKey: key.rawValue) as? Double
    }
    
    func integer(forKey key: Keys) -> Int? {
        restore(forKey: key.rawValue) as? Int
    }
    
    func remove(forKey key: Keys){
        
        userDefaults.removeObject(forKey: key.rawValue)
        
    }
    
}
