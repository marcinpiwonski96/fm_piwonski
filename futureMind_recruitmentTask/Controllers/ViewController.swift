//
//  ViewController.swift
//  futureMind_recruitmentTask
//
//  Created by Marcin Piwoński on 28/01/2019.
//  Copyright © 2019 Marcin Piwoński. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController {
    
    var items = [CellData]()
    var refreshControl = UIRefreshControl()
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //TODO :- refactor
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        //for dynamically resizing cells
        setupTableView()
        

        performDataRequest()

    }
    
    @objc func refresh(_ sender : Any){
        performDataRequest()
    }
    
    private func performDataRequest(){
        
        NetworkingManager.basicRequest(
            endpoint: Endpoint.recruitmentTask(),
            
            onSuccess: {
                [unowned self]
                result in
                let finalResult = result as! [CellData]
                self.updateTableView(with: finalResult)
                                        
            },
            onFailure: {
                [unowned self]
                error in
                print(error)
                self.showAlertWithError(error)
            }
        )
    }
    
    private func updateTableView(with result: [CellData]){
        
        //TODO :- check if item already exists
        
        self.items += result
        //sort by orderId
        self.items = self.items.sorted(by: { $0.orderId < $1.orderId })
        self.items.forEach { (cell) in
            print(cell.orderId)
        }
        print("count:\(self.items.count)")
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            
        }
        //TODO :- updateCoreData
    }
    
    private func showAlertWithError(_ error: Error){
        
        let alert = UIAlertController.init(title: "Couldn't fetch data", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource{
    
    
    func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath) as! DataTableViewCell
        let item = items[indexPath.row]
        cell.setup(withItem : item)
        
        return cell
    }
    

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        guard let urlString = item.urlString, let url = URL(string: urlString) else{
            //no url
            return
        }
        startWebView(url)
        
    }
    
    private func startWebView(_ url: URL){
        let vc = SFSafariViewController(url: url)
        self.present(vc, animated: true, completion: nil)
        print(url)
    }

}
