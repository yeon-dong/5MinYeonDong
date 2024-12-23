//
//  Message.swift
//  fiveMin
//
//  Created by jsj on 12/19/24.
//

import Foundation

struct Message : Codable{
    let id: String
    let senderId: String
    let text: String
    let timestamp: TimeInterval
}
