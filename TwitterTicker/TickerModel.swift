//
//  TickerModel.swift
//  TwitterTicker
//
//  Created by Jeremy Chang on 8/22/15.
//  Copyright (c) 2015 Jeremy Chang. All rights reserved.
//

import Foundation
import SwifteriOS


class TickerModel{
    
    var tweets : [Tweet] = [Tweet]()
    var maxSize = 30
    let simpleSpamFilter = SimpleSpamFilter()
    let repeatSpamFilter = RepeatSpamFilter(filterStrength: 100)
    var notifyViewCallback : ((isDelete: Bool, index: Int) -> Void)? = nil
    var acceptingTweets = false;
    
    class Tweet{
        
        let text: String!
        
        init (text: String){
            self.text = text
        }
    }
    
    
    init(notifyCallBack: ((isDelete: Bool, index: Int) -> Void)){
        notifyViewCallback = notifyCallBack
        println("Model : Initialized with default size, notify callback function set.")
        println("Model: Accepting Tweets.")
        acceptingTweets = true;
    }
    
    init(maxSize: Int?, notifyCallBack: ((isDelete: Bool, index: Int) -> Void)){
        self.notifyViewCallback = notifyCallBack
        if (maxSize != nil) {
            self.maxSize = maxSize!
            println("Model: Initialized with size of \(maxSize)")
        }
        println("Model: Notify callback function set.")
        println("Model: Accepting Tweets.")
        acceptingTweets = true;
    }
    
    init(maxSize: Int?){
        if (maxSize != nil) {
            self.maxSize = maxSize!
            println("Model: Initialized with size of \(maxSize)")
        }
        println("Model: Notify callback function not set.")
        println("Model: Not Accepting Tweets.")
        acceptingTweets = false
        notifyViewCallback = nil
    }
    
    init(){
        println("Model: Initialized with default size.")
        println("Model: Notify callback function not set.")
        println("Model: Not Accepting Tweets.")
        
    }
    
    func setNotifyCallBack(notifyCallBack: (isDelete:Bool, index: Int) -> Void ){
        self.notifyViewCallback = notifyCallBack
        println("Model: Notify callback function set.")
    }
    
    
    func setAcceptTweets(acceptingTweets: Bool){
        self.acceptingTweets = acceptingTweets
        println("Model: Accepting Tweets: \(acceptingTweets)")
    }
    
    func getTweet(index: Int) -> Tweet?{
        if(index >= tweets.count){
            return nil
        }else{
            return tweets[index]
        }
    }
    
    func clearTweets(){
        while tweets.count != 0 {
            removeFromFront()
        }
    }
    
    func getSize() -> Int{
        return tweets.count
    }
    
    func processAndAddTweet(tweet : Dictionary<String, JSONValue>){
        //println("Model: tweet received")
        if acceptingTweets == true{
            if let text = tweet["text"]?.string{
                //println("Model: text to test: \(text)")
                if(passesFilters(text)){
                    println("Model: Tweet inserted with text: \n\(text)")
                    insertAtFront(Tweet(text: text))
                    if(tweets.count > maxSize){
                        removeFromBack()
                    }
                }
            }
        }
    }
    
    private func insertAtFront(tweet : Tweet){
        tweets.insert(tweet, atIndex: 0)
        notifyViewCallback!(isDelete: false, index: 0 )
    }
    
    private func removeFromBack(){
        tweets.removeLast()
        notifyViewCallback!(isDelete: true, index: tweets.count )
    }
    
    private func removeFromFront(){
        tweets.removeAtIndex(0)
        notifyViewCallback!(isDelete: true, index: 0)
    }
    
    func setMaxSize(size : Int){
        maxSize = size;
        while(tweets.count > maxSize){
            removeFromBack()
        }
    }
    
    //Filtering Function
    private func passesFilters(text: String)-> Bool{
        if(!simpleSpamFilter.isValid(text)){
            return false
        }
        if(!repeatSpamFilter.isValid(text)){
            return false
        }
        return true;
    }
    

    

}