//
//  HashTagCell.swift
//  TwitterTicker
//
//  Created by Jeremy Chang on 8/26/15.
//  Copyright (c) 2015 Jeremy Chang. All rights reserved.
//

import UIKit

class HashTagCell: UITableViewCell {
    
    
    @IBOutlet weak var hashTagLabel: UILabel! = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}