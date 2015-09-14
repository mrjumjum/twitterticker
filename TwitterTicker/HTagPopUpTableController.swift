//
//  File.swift
//  TwitterTicker
//
//  Created by Jeremy Chang on 8/25/15.
//  Copyright (c) 2015 Jeremy Chang. All rights reserved.
//

import UIKit

class HTagPopUpTableController: UITableViewController{
    
    var twitterClient: TwitterStreamClient!
    var model: TickerModel!
    
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return twitterClient.getHashTags().count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HashTagCell", forIndexPath: indexPath) as! HashTagCell
        
        if let hashtag = twitterClient?.getHashTags()[indexPath.row]{
            cell.hashTagLabel.text = "#" + hashtag
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            twitterClient.removeHashTag(nil, index: indexPath.row)
            model.clearTweets()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    

}