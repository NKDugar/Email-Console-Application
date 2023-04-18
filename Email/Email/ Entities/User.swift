//
//  User.swift
//  Email
//
//  Created by naveen-pt6301 on 14/02/23.
//

import Foundation

 struct User{
    
    let Name: String
    let EmailID: String
    let password: String
    var listOfFolders: [Folder]
    
    init(){
        Name = " "
        EmailID = " "
        password = " "
        listOfFolders = [ ]
    }
    
    init(Name: String, EmailID: String, password: String) {
        self.Name = Name
        self.EmailID = EmailID
        self.password = password
        
        self.listOfFolders = [Folder(name: "Inbox") , Folder(name: "Sent"),Folder(name: "Bin") ]
    }
   
    
     
}

