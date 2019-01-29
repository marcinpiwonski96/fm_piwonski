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
    @IBOutlet weak var pictureView: ImageViewFromUrl!
    @IBOutlet weak var modifiedLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
                super.awakeFromNib()
    }
    
    
    func setup(withItem item : CellData){
        self.titleLabel.text = item.title
        self.modifiedLabel.text = "Modified: \(item.modificationDateString)"
        self.descriptionLabel.text = item.descriptionOnly
       
        let cachingKey = CachingKey(urlString: item.imageUrlString, title: item.title, modificationDate: item.modificationDateString)

        self.pictureView.imageFromServerWitchCachingKey(cachingKey)
       
        
    }
    
    
    
    

}
