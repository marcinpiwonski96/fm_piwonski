//
//  BaseViewController.swift
//  futureMind_recruitmentTask
//
//  Created by Marcin Piwoński on 29/01/2019.
//  Copyright © 2019 Marcin Piwoński. All rights reserved.
//

import UIKit
import SafariServices

class BaseViewController: UIViewController {

    var spinner : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showAlertWithError(_ error: Error){
        let alert = UIAlertController.init(title: "Couldn't fetch data", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    func displaySpinner(onView : UIView){
        guard self.spinner == nil else {
            return
        }
        
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
    
        self.spinner = spinnerView
    }
    
    func removeSpinner() {
        if let spinner = self.spinner {
            DispatchQueue.main.async {
                spinner.removeFromSuperview()
            }
            self.spinner = nil
        }
    }
    
    func startWebView(_ url: URL){
        let vc = SFSafariViewController(url: url)
        self.present(vc, animated: true)
    }
    
}
