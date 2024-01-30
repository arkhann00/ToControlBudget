//
//  SettingsViewModel.swift
//  ToControlBudet
//
//  Created by Арсен Хачатрян on 21.12.2023.
//

import Foundation

protocol SettingsViewModelProtocol {
    
    func saveNewCurrency(currencyIndex:Int, currencyString:String)
    func fetchCurrencyIndex() -> Int
    func fetchIsUpdateMonthlyBudget() -> Bool
    func fetchMonthlyBudgetForTextField() -> String
    func saveMonthlyBudget(maybeNewMonthlyBudget str:String, isUpdateMonthlyBudget on:Bool) -> Bool
}

final class SettingsViewModel: SettingsViewModelProtocol {
    
    let userDefaults:UserDefaultsManagerProtocol = UserDefaultsManager.shared
    let controlBudgetViewModel:ControlBudgetViewModelProtocolForSettings = ControlBudgetViewModel()
    
    func saveNewCurrency(currencyIndex: Int, currencyString: String) {
//        print(currencyString)
        controlBudgetViewModel.convertCurrency(currencySymbol: currencyString, currencyIndex: currencyIndex)
        
    }
    
    
    
    func fetchCurrencyIndex() -> Int {
        return userDefaults.integer(forKey: .numOfCurrency) ?? 0
    }
    
    func fetchIsUpdateMonthlyBudget() -> Bool {
        return userDefaults.bool(forKey: .isUpdateMonthlyBudget) ?? false
    }
    
    func fetchMonthlyBudgetForTextField() -> String {
        guard let monthlyBudget = userDefaults.double(forKey: .monthlyBudget) else { return "" }
        
        if round(monthlyBudget) == monthlyBudget {
            let strBudget = String(Int(monthlyBudget))
            return strBudget
        } else {
            let strBudget = String(monthlyBudget).replacingOccurrences(of: ".", with: ",")
            return strBudget
        }
        
    }
    
    func saveMonthlyBudget(maybeNewMonthlyBudget str:String, isUpdateMonthlyBudget on:Bool) -> Bool {
        
        if on {
            
            let newPossibleCostValue = str.replacingOccurrences(of: ",", with: ".")
            
            guard let newMonthlyBudget = Double(newPossibleCostValue),
                  round(newMonthlyBudget * 100)/100 == newMonthlyBudget else { return false }
            
            userDefaults.set(on, forKey: .isUpdateMonthlyBudget)
            userDefaults.set(newMonthlyBudget, forKey: .monthlyBudget)
            
            let calendar = Calendar.current
            
            let startDate = calendar.startOfDay(for: Date.now)
            
            userDefaults.set(startDate, forKey: .startDate)
            
            
        } else {
            
            userDefaults.set(on, forKey: .isUpdateMonthlyBudget)
            
        }
        
        
        
        return true
        
    }
    
}
