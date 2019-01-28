//
//  ViewController.swift
//  futureMind_recruitmentTask
//
//  Created by Marcin Piwoński on 28/01/2019.
//  Copyright © 2019 Marcin Piwoński. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var items = [CellData]()
    var refreshControl = UIRefreshControl()
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
//
//        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
//        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
//        tableView.addSubview(refreshControl)
//
        for _ in 0...10{
            performDataRequest()
        }
    }
    
    
    private func performDataRequest(){
        
        NetworkingManager.basicRequest(
            endpoint: Endpoint.recruitmentTask(),
            
            onSuccess: {
                result in
                let finalResult = result as! [CellData]
                print("descriptionOnly: \(finalResult[0].descriptionOnly)\nURLOnly: \(finalResult[0].urlString)")
                self.updateTableView(with: finalResult)
                                        
            },
            onFailure: {
                error in
                print(error)
                self.showAlertWithError(error)
            }
        )
    }
    
    private func updateTableView(with result: [CellData]){
        //sort by orderId
        let resultSorted = result.sorted(by: { $0.orderId < $1.orderId })
        resultSorted.forEach { (celldata) in
            print("\(celldata.orderId)")
        }
        
        DispatchQueue.main.async {
            //TODO :- updateTV
        }
        //TODO :- updateCoreData
    }
    
    private func showAlertWithError(_ error: Error){
        
        let alert = UIAlertController.init(title: "Couldn't fetch data", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default))
        self.present(alert, animated: true)
    }

}


extension ViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
