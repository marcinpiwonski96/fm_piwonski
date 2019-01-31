//
//  ViewControllerTableViewDelegate.swift
//  futureMind_recruitmentTask
//
//  Created by Marcin Piwoński on 30/01/2019.
//  Copyright © 2019 Marcin Piwoński. All rights reserved.
//

import UIKit

//delegate & datasource
extension ViewController : UITableViewDelegate, UITableViewDataSource{
    
    func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        //for dynamically resizing cells
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = fetchedResultController.sections?.first?.numberOfObjects {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath) as! DataTableViewCell

        if let data = fetchedResultController.object(at: indexPath) as? DataModel {
            cell.setup(withData: data)
        }
    
        cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? Colors.accent : Colors.accent2
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = fetchedResultController.object(at: indexPath) as? DataModel else {
            return
        }
        guard let urlString = data.urlString, let url = URL(string: urlString) else{
            self.showAlertWithError(NetworkingError.URLNotValid)
            return
        }
        startWebView(url)
    }
    
    
    //just a fancy little feature :) top bar color changes to the same color as top cell
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let currentIndexPaths = tableView.indexPathsForVisibleRows else {
            return
        }
        
        guard !currentIndexPaths.isEmpty else {
            return
        }
        let indexPath = currentIndexPaths[0]
        
        
        UIView.animate(withDuration: 0.1) {
            self.view.backgroundColor = indexPath.row % 2 == 0 ? Colors.accent : Colors.accent2
        }
    }
    
}
