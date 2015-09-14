//
//  DetailViewController.swift
//  TwitterTicker
//
//  Created by Jeremy Chang on 8/21/15.
//  Copyright (c) 2015 Jeremy Chang. All rights reserved.
//

import UIKit

class DetailController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    @IBAction func swipeDownToUnwind(sender: UISwipeGestureRecognizer) {
        performSegueWithIdentifier("unwindToTweetTable", sender: self)
        println("Captured a movement")
    }
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail: AnyObject = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail as? String
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

