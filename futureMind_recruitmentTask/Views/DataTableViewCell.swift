//
//  DataTableViewCell.swift
//  futureMind_recruitmentTask
//
//  Created by Marcin Piwoński on 28/01/2019.
//  Copyright © 2019 Marcin Piwoński. All rights reserved.
//

import UIKit

class DataTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pictureView: ImageViewFromUrl! {
        didSet{
            pictureView.layer.masksToBounds = true
            pictureView.layer.cornerRadius = 40
            pictureView.layer.borderWidth = 10
            pictureView.layer.borderColor = UIColor.gray.cgColor
        }
    }
    @IBOutlet weak var modifiedLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
                super.awakeFromNib()
    }
    
    
    func setup(withData data : DataModel){
        self.titleLabel.text = data.title
        self.modifiedLabel.text = "Modified: \(data.modificationDate)"
        self.descriptionLabel.text = data.descriptionOnly
       
        let cachingKey = CachingKey(urlString: data.imageUrlString, title: data.title, modificationDate: data.modificationDate)

        self.pictureView.imageFromServerWitchCachingKey(cachingKey)
    }

}
