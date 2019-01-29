//
//  ViewController.swift
//  futureMind_recruitmentTask
//
//  Created by Marcin Piwoński on 28/01/2019.
//  Copyright © 2019 Marcin Piwoński. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: BaseViewController {
    
    var items = [CellData]()
    var refreshControl = UIRefreshControl()
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        displaySpinner(onView: tableView)
        setupRefreshControl()
        setupTableView()
        //initial data request for when the view loads
        performDataRequest()
    }
    
   
    private func setupRefreshControl(){
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
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
                self.updateData(with: finalResult)
                self.removeSpinner()
                                        
            },
            onFailure: {
                [unowned self]
                error in
                print(error)
                self.removeSpinner()
                self.showAlertWithError(error)
            }
        )
    }
    
    private func updateData(with result: [CellData]){
        
        self.items += result
        //sort by orderId
        self.items = self.items.sorted(by: { $0.orderId < $1.orderId })
       
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource{
    
    //for dynamically resizing cells
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
        
        if indexPath.row % 2 == 0{
            cell.contentView.backgroundColor = UIColor(named: "Accent")
        } else {
            cell.contentView.backgroundColor = UIColor(named: "Accent2")
        }
        
        
        return cell
    }
    

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        guard let urlString = item.urlString, let url = URL(string: urlString) else{
            self.showAlertWithError(NetworkingError.URLNotValid)
            return
        }
        startWebView(url)
    }
    
    private func startWebView(_ url: URL){
        let vc = SFSafariViewController(url: url)
        self.present(vc, animated: true)
    }
}
