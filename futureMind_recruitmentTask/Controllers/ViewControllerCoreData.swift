//
//  ViewControllerCoreData.swift
//  futureMind_recruitmentTask
//
//  Created by Marcin Piwoński on 30/01/2019.
//  Copyright © 2019 Marcin Piwoński. All rights reserved.
//

import Foundation
import CoreData

//Core Data manipulation
extension ViewController: NSFetchedResultsControllerDelegate{
    
    private func createDataEntityFromDictionary(_ dictionary: [String: Any]) -> NSManagedObject?{
        
        let context = CoreDataStack.shared.persistentContainer.viewContext
        
        let dataEntity = DataModel(context : context)
        dataEntity.title = dictionary[JSONKeys.title.rawValue] as! String
        dataEntity.modificationDate = dictionary[JSONKeys.modificationDate.rawValue] as! String
        dataEntity.fullDescription = dictionary[JSONKeys.fullDescription.rawValue] as! String
        dataEntity.imageUrlString = dictionary[JSONKeys.imageUrlString.rawValue] as! String
        dataEntity.orderId = Int32(dictionary[JSONKeys.orderId.rawValue] as! Int)
        
        return dataEntity
    }
    
    func saveInCoreDataWithArray(array: [[String: Any]]){
        _ = array.map{ self.createDataEntityFromDictionary($0) }
        do {
            try CoreDataStack.shared.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
            self.showAlertWithError(error)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
}

