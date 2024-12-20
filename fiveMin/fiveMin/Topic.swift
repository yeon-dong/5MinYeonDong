//
//  Topic.swift
//  fiveMin
//
//  Created by jsj on 12/20/24.
//

import Foundation

struct Topic {
    let title : String
    let messages : [Message]
    let vote : Int
    let activate : Bool
    let startTime : Date
}
