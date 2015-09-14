//
//  Filters.swift
//  TwitterTicker
//
//  Created by Jeremy Chang on 8/23/15.
//  Copyright (c) 2015 Jeremy Chang. All rights reserved.
//

import Foundation


protocol SpamFilter{
    func isValid(text: String) -> Bool
}

class SimpleSpamFilter : SpamFilter{
    func isValid(text: String) -> Bool {
        if (text.rangeOfString("t.co") != nil){
            return false
        }
        if (text.rangeOfString("ollow") != nil){
            return false
        }
        if (text.rangeOfString("http") != nil){
            return false
        }
        return true
    }
}

class RepeatSpamFilter : SpamFilter{
    var queue : EnforcedSizeQueue
    var strength : Int
    
    init(filterStrength : Int){
        strength = filterStrength
        queue = EnforcedSizeQueue(size: strength)
    }
    
    func isValid(text: String) -> Bool {
        var isDuplicate : Bool = queue.containsAndRemove(text)
        queue.enqueue(text)
        queue.dequeue()
        return !isDuplicate
    }
}