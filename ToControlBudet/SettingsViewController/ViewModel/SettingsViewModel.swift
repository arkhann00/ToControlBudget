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
    func saveInUserDefaultsCurrency(currencyIndex: Int, currencyString: String)
}

final class SettingsViewModel: SettingsViewModelProtocol {
    
    let userDefaults:UserDefaultsManagerProtocol = UserDefaultsManager.shared
    let controlBudgetViewModel:ControlBudgetViewModelProtocolForSettings = ControlBudgetViewModel()
    
    func saveNewCurrency(currencyIndex: Int, currencyString: String) {
        saveInUserDefaultsCurrency(currencyIndex: currencyIndex, currencyString: currencyString)
        print(currencyString)
        controlBudgetViewModel.convertCurrency(currencySymbol: currencyString, currencyIndex: currencyIndex)
        
    }
    
    func saveInUserDefaultsCurrency(currencyIndex: Int, currencyString: String){
        
        userDefaults.set(currencyIndex, forKey: .numOfCurrency)
        userDefaults.set(" " + currencyString, forKey: .currency)
        
    }
    
    func fetchCurrencyIndex() -> Int {
        return userDefaults.integer(forKey: .numOfCurrency) ?? 0
    }
    
}
