//
//  ViewController.swift
//  futureMind_recruitmentTask
//
//  Created by Marcin Piwoński on 28/01/2019.
//  Copyright © 2019 Marcin Piwoński. All rights reserved.
//

import UIKit
import CoreData

class ViewController: BaseViewController {
    
    var refreshControl = UIRefreshControl()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fireRequestOnFirstLaunch()
        setupRefreshControl()
        setupTableView()
        
    }
    
    //show spinner on first launch of the app, perform initial request
    func fireRequestOnFirstLaunch(){
        do {
            try self.fetchedResultController.performFetch()
            let objectsNumber = self.fetchedResultController.sections?[0].numberOfObjects
            if let objectsNo = objectsNumber {
                if objectsNo == 0 {
                    displaySpinner(onView: self.view)
                    //initial data request for when the view loads
                    performDataRequest()
                }
            }
        } catch let error  {
            print("error: \(error)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        imageCache.removeAllObjects()
    }
    
    private func setupRefreshControl(){
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to fetch new")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender : Any){
        performDataRequest()
    }
    
    private func performDataRequest(){
        
        NetworkingManager.basicRequest(endpoint: Endpoint.recruitmentTask()) {
            [unowned self]
            (result) in
            switch result{
            case .success(let data):
                DispatchQueue.main.async {
                    self.deleteStoredData()
                    self.saveInCoreDataWithArray(array: data)
                }
            case .failure(let error):
                self.showAlertWithError(error)
            }
            
            DispatchQueue.main.async {
                self.removeSpinner()
                self.refreshControl.endRefreshing()
            }
        }
    }
        
    lazy var fetchedResultController : NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: DataModel.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key:String(describing: "orderId"),ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
}

