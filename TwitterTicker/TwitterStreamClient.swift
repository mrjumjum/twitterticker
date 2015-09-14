//
//  TwitterStreamClient.swift
//  TwitterTicker
//
//
//  Retrieves tweets with associated hashtags in realtime.
//
//
//
//
//  Created by Jeremy Chang on 8/21/15.
//  Copyright (c) 2015 Jeremy Chang. All rights reserved.
//

import SwifteriOS
import Accounts
import Foundation

class TwitterStreamClient {
    var swifter: Swifter?
    var hashtagsToFollow: [String] = []
    var clientCallBack: ((tweet: Dictionary<String, JSONValue>) -> Void)?
    var clientAuthorized: Bool = false
    
    let consumerKey : String = "IMM2WIPUANMErP6N28TGa10oi"
    let consumerSecret : String = "lRfXp6h9JbodXZ0kPX0KMZ6O8vwijyf8kxSwMejPJKLz7Cy4HR"
    
    init(tweetCallBack:((tweet: Dictionary<String, JSONValue>) -> Void)?, resultCallBack: (wasSuccessful: Bool, explanation: String?) -> Void ){
        self.swifter = Swifter(consumerKey: consumerKey, consumerSecret: consumerSecret)
        let acctStore = ACAccountStore()
        let acctType = acctStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        acctStore.requestAccessToAccountsWithType(acctType, options: nil){
            granted, error in
            
            if(!granted){
                println("TwitterStreamClient: Access to Twitter Accounts NOT Permitted")
                resultCallBack(wasSuccessful: false, explanation: "Twitter Account Permission Not Granted")
            }else{
                println("TwitterStreamClient: Access to Twitter Accounts Permitted")
                if let accounts = acctStore.accountsWithAccountType(acctType), account = accounts.first as? ACAccount{
                    println("TwitterStreamClient: Logged in with username: \(account.username)")
                    self.swifter = Swifter(account: account)
                    self.clientCallBack = tweetCallBack
                    self.clientAuthorized = true
                    resultCallBack(wasSuccessful: true, explanation: nil)
                }else{
                    resultCallBack(wasSuccessful: false, explanation: "No Twitter Account Exists")
                }
            }
        }
    }
    
    func isReady() -> Bool{
        return clientAuthorized
    }
    
    func addHashTag(hashtag: String?){
        if var tag = hashtag{
            let firstLetter = tag[tag.startIndex]
            if firstLetter == "#"{
               tag.removeAtIndex(tag.startIndex)
            }
            hashtagsToFollow.insert(tag, atIndex: 0)
            restartStream()
        }
    }
    
    func removeHashTag(hashtag: String?, index: Int?){
        if let ind = index{
            if(ind >= 0 || ind < hashtagsToFollow.count){
                hashtagsToFollow.removeAtIndex(ind)
            }
        }else if var tag = hashtag{
            for var i = 0; i < hashtagsToFollow.count; ++i{
                if(hashtagsToFollow[i] == tag){
                    hashtagsToFollow.removeAtIndex(i)
                }
            }
        }
        if(hashtagsToFollow.count > 0){
            restartStream()
        }
    }
    
    func getHashTags() -> [String]{
        return hashtagsToFollow
    }

    private func restartStream(){
        startStream()
    }
   /*
    func replaceHashTags(hashtags: String?){
        if let hashTagString = hashtags{
            var sanitizedString = hashTagString.stringByReplacingOccurrencesOfString( "#", withString: "")
            hashtagsToFollow = split(sanitizedString) {$0 == " "}
            startStream()
        }
    }*/
    
    func setTweetCallBack(callBack : ((Dictionary<String, JSONValue>) ->  Void)?){
        clientCallBack = callBack
    }
    
    private func startStream() -> Bool{
        if !clientAuthorized{
            return false
        }
        println("TwitterStreamClient: Attempting to Start Stream")
        swifter?.postStatusesFilterWithFollow(follow: nil, track: hashtagsToFollow, locations: nil, delimited: nil, stallWarnings: false, progress: {tweet in self.deliverTweet(tweet)}, stallWarningHandler: nil, failure: {error in println("TwitterStreamClient: Cannot Start Stream \(error)")} )
        return true;
    }
    
   
    //Delivers HashTag Tweet to clientCallback
    private func deliverTweet(tweet: Dictionary<String, JSONValue>?){
        if let tweetToSend = tweet, let callBack = clientCallBack{
            //println("TwitterStreamClient: tweet recieved")
            if(isHashTagTweet(tweetToSend)){
                //println("TwitterStreamClient: tweet delivered")
                callBack(tweet: tweetToSend)
            }
        }
    }
    
    private func isHashTagTweet(tweet: Dictionary<String, JSONValue>) -> Bool{
        if let text: String = tweet["text"]?.string{
            var sanitizedText = text.lowercaseString
            var containsHashTag = false
            for hashtag in hashtagsToFollow {
                if sanitizedText.rangeOfString("#" + hashtag.lowercaseString) != nil{
                    containsHashTag = true;
                }
            }
            return containsHashTag
        }
        return false
    }
}