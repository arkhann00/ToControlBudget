//
//  CoreData.swift
//  ToControlBudet
//
//  Created by Арсен Хачатрян on 08.12.2023.
//

import UIKit
import CoreData

protocol CoreDataModelProtocol {
    func adNewCostInContext(costs:[Cost], value:Double, describe: String, sign: String) -> [Cost]
    func fetchCostArray() -> [Cost]
    func deleteObject(object: NSManagedObject)
    func saveContext()
}

final class CoreDataModel: CoreDataModelProtocol {
    
    private init(){}
    static let shared = CoreDataModel()
    
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func adNewCostInContext(costs:[Cost], value:Double, describe: String, sign: String) -> [Cost] {
        
        var updatedArray = costs
        
        guard let newCostDescription = NSEntityDescription.entity(forEntityName: "Cost", in: context) else { return costs }
        
        let newCost = Cost(entity: newCostDescription, insertInto: context)
        
        newCost.value = value
        newCost.describe = describe
        newCost.sign = sign
        updatedArray.insert(newCost, at: 0)
        
        saveContext()
        
        return updatedArray
        
    }
    
    func saveContext(){
        
        do{
            
            try context.save()
            
            
        } catch let error as NSError { print(error.localizedDescription) }
        
    }
    
    func fetchCostArray() -> [Cost] {
        
        var costs:[Cost] = []
        
        let fetchRequest: NSFetchRequest<Cost> = Cost.fetchRequest()
        
        do {
            
            costs = try context.fetch(fetchRequest)
            
        } catch let error as NSError { print(error.localizedDescription) }
                
        return costs
        
    }
    
    func deleteObject(object: NSManagedObject) {
        
        context.delete(object)
        
    }
    
}
