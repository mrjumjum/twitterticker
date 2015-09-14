//
//  MasterViewController.swift
//  TwitterTicker
//
//  Created by Jeremy Chang on 8/21/15.
//  Copyright (c) 2015 Jeremy Chang. All rights reserved.
//

import UIKit
import SwifteriOS

class TweetTableController: UITableViewController{

    var model : TickerModel!
    
    
 /*   @IBAction func HashtagPopupOpened(sender: UIButton) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("HashTagPopup") as! UIViewController
        vc.modalPresentationStyle = UIModalPresentationStyle.Popover
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        popover.barButtonItem = sender as UIBarButtonItem
        popover.delegate = self
        presentViewController(vc, animated: true, completion:nil)
    }*/
    
    @IBAction func unwindToTweetTable(segue: UIStoryboardSegue) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
        while(model == nil){}
        model.setNotifyCallBack(modelChangeNotify)
        model.setAcceptTweets(true)
    }
    
    func modelChangeNotify(isDelete: Bool, index: Int) -> Void{
        let indexPath = NSIndexPath(forRow: index, inSection: 0)
        if(!isDelete){
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }else{
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "masterShowDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                if let tweet = model.getTweet(indexPath.row){
                    (segue.destinationViewController as! DetailController).detailItem = tweet.text
                    
                    println("CHEKCKCKKEKCEKCE")
                }
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.getSize()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell

        if let tweet = model.getTweet(indexPath.row){
            cell.scrollingTextLabel?.text = tweet.text
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let currentCell = cell as? TweetCell{
            currentCell.scrollingTextLabel?.resetLabel()
        }
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            model.tweets.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

}

