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
        dataEntity.title =
        (dictionary[JSONKeys.title.rawValue] as? String) ?? "undefined"
        dataEntity.modificationDate = (dictionary[JSONKeys.modificationDate.rawValue] as? String) ?? "undefined"
        dataEntity.fullDescription = (dictionary[JSONKeys.fullDescription.rawValue] as? String) ?? "undefined"
        dataEntity.imageUrlString = (dictionary[JSONKeys.imageUrlString.rawValue] as? String) ?? "undefined"
        dataEntity.orderId = Int32((dictionary[JSONKeys.orderId.rawValue] as? Int) ?? 0)
        
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
    
    func deleteStoredData(){
        do {
            let context = CoreDataStack.shared.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: DataModel.self))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{ $0.map{ context.delete($0) } }
                CoreDataStack.shared.saveContext()
            } catch let error {
                print("error deleting: \(error)")
            }
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else {
                return
            }
            self.tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else{
                return
            }
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
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

