//
//  HashTagPopUpController.swift
//  TwitterTicker
//
//  Created by Jeremy Chang on 8/24/15.
//  Copyright (c) 2015 Jeremy Chang. All rights reserved.
//

import UIKit

class HTagPopUpController: UIViewController, UIPopoverPresentationControllerDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var HashTagInputField: UITextField!
    
    var twitterClient: TwitterStreamClient!
    var model: TickerModel!
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "hTagPopupEmbedPopupTable"{
            let hTagPopupTableCtrler = segue.destinationViewController as! HTagPopUpTableController
            hTagPopupTableCtrler.twitterClient = self.twitterClient
            hTagPopupTableCtrler.model = self.model
        }
    }
    override func viewDidLoad(){
        super.viewDidLoad()
        HashTagInputField.delegate = self
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func DismissKeyboard(){
        view.endEditing(true)
    }
    
    //MARK: - Popover Presentation Delegate
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        let navigationController = UINavigationController(rootViewController: controller.presentedViewController)
        let btnDone = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "dismiss")
        navigationController.topViewController.navigationItem.rightBarButtonItem = btnDone
        return navigationController
    }
    
    //MARK: - TextField Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let hashtag = textField.text
        if hashtag != ""{
            twitterClient.addHashTag(hashtag)
            model.clearTweets()
        }
        textField.text = ""
        
        let hashTagTableCtrler = self.childViewControllers[0] as! UITableViewController
        hashTagTableCtrler.tableView.reloadData()
        
        return true
    }
}