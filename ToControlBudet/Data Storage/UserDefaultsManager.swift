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
    func date(forKey key: UserDefaultsManager.Keys) -> Date?
}

final class UserDefaultsManager{
    
    static let shared = UserDefaultsManager()
    
    private init() {}
    
    public enum Keys: String {
        
        case budget // Оставшийся после затрат бюджет
        case currency // Валюта
        case numOfCurrency // Номер валюты в настройках
        case coefficient // Коэфициент валюты
        case isUpdateMonthlyBudget // Вкл / выкл обновление месячного бюджета
        case monthlyBudget // Сумма обновления месячного бюджета 
        case startDate // Дата с которой считается месячный бюджет
        
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
    
    func date(forKey key: Keys) -> Date? {
        
        restore(forKey: key.rawValue) as? Date
        
    }
    
    func remove(forKey key: Keys){
        
        userDefaults.removeObject(forKey: key.rawValue)
        
    }
    
}
