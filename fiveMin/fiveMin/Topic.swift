//
//  Topic.swift
//  fiveMin
//
//  Created by jsj on 12/20/24.
//

import Foundation

struct Topic {
    let title : String
    var messages : [Message]
    var vote : Int
    var activate : Bool
    let startTime : Date
}
