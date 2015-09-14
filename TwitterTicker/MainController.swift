//
//  MainController.swift
//  TwitterTicker
//
//  Created by Jeremy Chang on 9/7/15.
//  Copyright (c) 2015 Jeremy Chang. All rights reserved.
//

import Foundation
import UIKit

class MainController : UIViewController{
    var twitterClient : TwitterStreamClient!
    var model : TickerModel!
    
    @IBOutlet weak var addHashTag: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        model = TickerModel()
        twitterClient = TwitterStreamClient(tweetCallBack: model.processAndAddTweet, resultCallBack: handler)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // self.navigationItem.leftBarButtonItem = self.editButtonItem()
        // self.automaticallyAdjustsScrollViewInsets = false;
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController?.navigationBar.translucent = false
        //let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        //self.navigationItem.rightBarButtonItem = addButton
    }
    
    
    func handler(wasSuccessful: Bool, explanation: String?) -> Void{
        if wasSuccessful, let client = twitterClient{
            
        }else{
            let alertController = UIAlertController(title: "Login Error", message:
                "Cannot log in to Twitter. Make sure app has proper Twitter account credentials and permissions", preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            
            println("Master View Controller: Error on Twitter Client init: \(explanation)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if segue.identifier == "mainEmbedTweetTable"{
            let tableViewController = segue.destinationViewController as! TweetTableController
            tableViewController.model = self.model
        }
        if segue.identifier == "mainPopOverHTagPopUp" {
            let popoverViewController = segue.destinationViewController as! HTagPopUpController
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            popoverViewController.popoverPresentationController!.delegate = popoverViewController
            popoverViewController.twitterClient = self.twitterClient
            popoverViewController.model = self.model
        }
    }
}


    
    