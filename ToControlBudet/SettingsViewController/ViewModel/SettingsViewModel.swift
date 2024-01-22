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
    
}
