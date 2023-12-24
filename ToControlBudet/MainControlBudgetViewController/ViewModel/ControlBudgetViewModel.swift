//
//  ControlBudgetViewModel.swift
//  ToControlBudet
//
//  Created by Арсен Хачатрян on 08.12.2023.
//

import Foundation
import UIKit
//MARK: - Основной протокол модели для контроллера
protocol ControlBudgetViewModelProtocol {
    
    func numberOfSectionsInCostTableView() -> Int
    func numberOfRowsInCostsTableView() -> Int
    func saveBudgetValue()
    func fetchBudgetValue() -> String?
    func fetchCosts()
    func addNewCost(possibleCost string: String?, description: String) -> Bool
    func tryToChangeBudget(possibleBudget string: String?) -> String?
    func fetchCostValue (indexOfCost index: Int) -> String
    func fetchSignOfCost(indexOfCost index: Int) -> String
    func fetchDescriptionOfCost (indexOfCost index: Int) -> String
    func calculateHeightOfCostCell (indexOfCost index: Int) -> CGFloat
    func deleteCost(with index: Int)
    func changeCost(newPossibleCost value:String?, description: String, index: Int) -> Bool
    func isEnableToChangeCost(index: Int) -> Bool
    
}
//MARK: - Протокол модели для модели настроек
protocol ControlBudgetViewModelProtocolForSettings {
    func convertCurrency(currencySymbol:String, currencyIndex:Int)
}

//MARK: - Реализация основного протокола для контроллера
final class ControlBudgetViewModel: ControlBudgetViewModelProtocol {
    
    var costs:[Cost] = []
    var budget:Double = -1
    var userDefaults:UserDefaultsManagerProtocol = UserDefaultsManager.shared
    var currencySign = " ₽"
    let coreDataModel:CoreDataModelProtocol = CoreDataModel.shared
    let networkManager = NetworkManager.shared
    var coefficient:Double = 1.0
    
    //MARK: - Количество секций
    func numberOfSectionsInCostTableView() -> Int {
        return 1
    }
    //MARK: - Количество ячеек
    func numberOfRowsInCostsTableView() -> Int {
        return costs.count
    }
    //MARK: - Сохранение суммы бюджета
    func saveBudgetValue() {
        
        budget = Double(round(100 * budget) / 100)
        userDefaults.set(budget, forKey: .budget)
        
    }
    //MARK: - Извлечения сохраненной суммы бюджета из хранилища
    func fetchBudgetValue() -> String? {
        
        guard let lastBudget = userDefaults.double(forKey: .budget) else { return "Non Value" }
        
        budget = lastBudget
        coefficient = userDefaults.double(forKey: .coefficient) ?? 1
        
        currencySign = userDefaults.string(forKey: .currency) ?? " ₽"
        print(budget, coefficient, currencySign)
        if round(budget) == budget {
            let strBudget = String(Int(budget))
            return strBudget + currencySign
        } else {
            let strBudget = String(budget).replacingOccurrences(of: ".", with: ",")
            return strBudget + currencySign
        }
        
    }
    //MARK: - Изменение суммы бюджета (в случае корректных данных)
    func tryToChangeBudget(possibleBudget string: String?) -> String? {
        
        guard let possibleNum = string else { return nil }
        
        let possibleBudget = possibleNum.replacingOccurrences(of: ",", with: ".")
        
        guard let newBudget = Double(possibleBudget),
              round(newBudget * 100)/100 == newBudget else { return nil }
        
        budget = newBudget
        
        if round(budget) == budget {
            let strBudget = String(Int(budget))
            return strBudget + currencySign
        } else {
            let strBudget = String(budget).replacingOccurrences(of: ".", with: ",")
            return strBudget + currencySign
        }
        
    }
    //MARK: - Добавление затраты
    func addNewCost(possibleCost value: String?, description: String) -> Bool {
        
        guard let possibleNum = value else { return false }
        
        let possibleCostValue = possibleNum.replacingOccurrences(of: ",", with: ".")
        
        guard let newCostValue = Double(possibleCostValue),
              round(newCostValue * 100)/100 == newCostValue else { return false }
        
        
        costs = coreDataModel.adNewCostInContext(costs: costs, value: newCostValue, describe: description, sign: currencySign)
        
        guard budget - newCostValue >= 0 else { return false }
        
        budget -= newCostValue
        saveBudgetValue()
        
        return true
        
    }
    //MARK: - Извлечение затрат из хранилища
    func fetchCosts(){
        costs = coreDataModel.fetchCostArray()
        costs = costs.reversed()
    }
    //MARK: - Возвращение суммы определенной затраты
    func fetchCostValue (indexOfCost index: Int) -> String {
        
        var correctValue = ""
        
        
        
        if round(costs[index].value) == costs[index].value {
            correctValue = String(Int(costs[index].value))
        } else {
            correctValue = String(costs[index].value).replacingOccurrences(of: ".", with: ",")
        }
        
        return String(correctValue)
    }
    //MARK: - Возвращение валюты определенной затраты
    func fetchSignOfCost(indexOfCost index: Int) -> String {
        return currencySign
    }
    //MARK: - Возвращение описания определенной затраты
    func fetchDescriptionOfCost (indexOfCost index: Int) -> String {
        return costs[index].describe ?? ""
    }
    //MARK: - Возвращение размера ячейки в зависимости от размера описания
    func calculateHeightOfCostCell (indexOfCost index: Int) -> CGFloat {
        
        let string = costs[index].describe
        let attributes : [NSAttributedString.Key : Any] = [NSAttributedString.Key(rawValue:
           NSAttributedString.Key.font.rawValue) : UIFont.systemFont(ofSize:
           15.0)]

        let attributedString : NSAttributedString = NSAttributedString(string: string!, attributes: attributes)
        let rect : CGRect = attributedString.boundingRect(with: CGSize(width: 222.0, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)

        let requredSize:CGRect = rect
        return requredSize.height
        
        
    }
    //MARK: - Удаление затраты
    func deleteCost(with index: Int) {
        
        let deletedCostValue = costs[index].value
        let deletedCost = costs[index]
        
        budget += deletedCostValue
        saveBudgetValue()
        
        coreDataModel.deleteObject(object: deletedCost)
        coreDataModel.saveContext()
        
        costs.remove(at: index)
        
    }
    //MARK: - Изменение затраты
    func changeCost(newPossibleCost value:String?, description: String, index: Int) -> Bool {
        
        guard let newPossibleNum = value else { return false }
        
        let newPossibleCostValue = newPossibleNum.replacingOccurrences(of: ",", with: ".")
        
        guard let newCostValue = Double(newPossibleCostValue),
              round(newCostValue * 100)/100 == newCostValue else { return false }
        
        budget += (costs[index].value - newCostValue)
        saveBudgetValue()
        
        costs[index].value = newCostValue
        costs[index].describe = description
        coreDataModel.saveContext()
        
        return true
        
    }
    
    func isEnableToChangeCost(index: Int) -> Bool {
        
        if costs[index].sign == currencySign {
            return true
        }
        
        return false
        
    }
    
    
}
//MARK: - Расширение реализации протокола для модели настроек
extension ControlBudgetViewModel:ControlBudgetViewModelProtocolForSettings {
    
    //MARK: - Конвертер из одной валюты в другую
    func convertCurrency(currencySymbol:String, currencyIndex:Int) {
        
        currencySign = " " + currencySymbol
        
        networkManager.fetchCurrency { [self] result in
            budget = userDefaults.double(forKey: .budget) ?? -1
            coefficient = userDefaults.double(forKey: .coefficient) ?? 1
            budget /= coefficient
            budget -= 1
            switch result {
                
            case .success(let rates):
                                
                switch currencySymbol {
                    
                case "$":
                    self.coefficient = rates["USD"]!
                case "€":
                    self.coefficient = rates["EUR"]!
                case "£":
                    self.coefficient = rates["GBP"]!
                default:
                    self.coefficient = 1
                    
                }
                
                userDefaults.set(coefficient, forKey: .coefficient)
                
                budget *= coefficient
                
                saveBudgetValue()
                
            case .failure(let error):
                print("Error in FetchCurrency \(error.localizedDescription)")
            }
            
            
        }
        
        
    }
    
}
