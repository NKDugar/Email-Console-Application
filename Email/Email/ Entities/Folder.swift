//
//  Folder.swift
//  Email
//
//  Created by naveen-pt6301 on 14/02/23.
//

import Foundation

public struct Folder {
    
    let name: String
    var unreadEmailsCount: Int = 0
    var listOfMails: [Emails] = []
    
    
    init(name: String) {
        self.name = name
    }
    
}
