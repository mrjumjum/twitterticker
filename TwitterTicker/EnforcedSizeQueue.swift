//
//  EnforcedSizeQueue.swift
//  TwitterTicker
//
//  Created by Jeremy Chang on 8/23/15.
//  Copyright (c) 2015 Jeremy Chang. All rights reserved.
//

import Foundation

class EnforcedSizeQueue{
    class Node{
        var next : Node?
        let value: String
        
        init(value: String, nextNode : Node?){
            next = nextNode
            self.value = value;
        }
    }
    
    var front: Node?
    var back: Node?
    var size: Int = 0
    var enforcedSize: Int!
    
    init(size : Int){
        enforcedSize = size
    }
    
    func enqueue(value : String){
        var tempNode : Node = Node(value: value, nextNode : nil)
        
        if(back == nil){
            front = tempNode
        }else{
            back!.next = tempNode
        }
        back = tempNode
        size++
    }
    
    func setMinimumSize(size : Int){
        enforcedSize = size
    }
    
    func dequeue(){
        if(front != nil){
            if(size > enforcedSize){
                front = front!.next
                size--
            }
        }
    }
    
    func containsAndRemove(value : String) -> Bool{
        if let frontNode = front{
            var tempNode : Node? = frontNode
            var prevNode : Node?
            while((tempNode != nil) && (tempNode?.value != value)){
                prevNode = tempNode
                tempNode = tempNode?.next
            }
            if(tempNode == nil){
                return false
            }else{
                prevNode?.next = tempNode?.next
                if(tempNode?.next == nil){
                    back = prevNode
                }
                size--
                return true
            }
        }else{
            return false
        }
    }
}