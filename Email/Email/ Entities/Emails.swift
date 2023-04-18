//
//  Emails.swift
//  Email
//
//  Created by naveen-pt6301 on 14/02/23.
//

import Foundation

public struct Emails{
    
    let toAddress: String
    let fromAddress: String
    let subject: String?
    let body: String?
    let cc: [String]?
    var isRead: Bool
    var isFavourite: Bool
    
    init() {
        self.toAddress = " "
        self.fromAddress = " "
        self.subject = " "
        self.body = " "
        self.cc = []
        self.isRead = false
        self.isFavourite = false
    }
    
    
    init(toAddress: String, fromAddress: String, subject: String? = nil, body: String? = nil, cc: [String]? = nil, isRead: Bool , isFavourite: Bool ) {
        self.toAddress = toAddress
        self.fromAddress = fromAddress
        self.subject = subject
        self.body = body
        self.cc = cc
        self.isRead = isRead
        self.isFavourite = isFavourite
    }
    
}
