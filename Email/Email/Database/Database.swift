//
//  Database.swift
//  Email
//
//  Created by naveen-pt6301 on 14/02/23.
//

import Foundation
import CryptoKit

class Database {
    
    static let shared  = Database()
    private init(){}
    
    private var emailAndUser: [String:User] = [ : ]
    private var AllEmails: [Emails] = [ ]
    private var  isUserLoggedIn: Bool = false
    
}

extension Database: AuthenticationContract {
    
    func logoutUser()->Bool{
        isUserLoggedIn = false
        return isUserLoggedIn
    }
    
    func registerUser(user:  User)->Bool{
        let hashedPassword = SHA256.hash(data: Data(user.password.utf8)).compactMap { String(format: "%02x", $0) }.joined()
        let newUser = User(Name: user.Name, EmailID: user.EmailID, password: hashedPassword)
        if emailAndUser[user.EmailID] == nil {
            emailAndUser[user.EmailID] = newUser
            return true
        }else{
            return false
        }
    }
    
    func loginUser(emailId: String , password: String)->User? {
        
        if isUserLoggedIn == false{
            let enteredPasswordHash = SHA256.hash(data: Data(password.utf8)).compactMap { String(format: "%02x", $0) }.joined()
            if enteredPasswordHash == emailAndUser[emailId]?.password  {
                print("user logged in succesfully")
                isUserLoggedIn = true
                return emailAndUser[emailId]
            }else{
                return nil
            }
        }else{
            print("logout current user to login ")
            return nil
        }
        
    }
}

extension Database {
    
    func validateUser(toAddress: String) -> Bool{
        
        if emailAndUser[toAddress] != nil{
            return true
        }else{
            return false
        }
       
    }
    
    func sendMail(email: Emails){
        AllEmails.append(email)
    }
    
    func validateCC(email: Emails) -> Bool {
        guard let cc = email.cc else {
            print("Authentication - All mails are empty.")
            return true
        }
        
        for mailID in cc {
            if mailID == "" {
                print("Authentication - no cc provided")
                return true
            }
            
            guard let _ = emailAndUser[mailID] else {
                print("Authentication - User is not registered with mail ID: \(mailID)")
                return false
            }
            
            if mailID == email.toAddress || mailID == email.fromAddress {
                print("Authentication - CC cannot have the same email ID as the fromAddress or toAddress: \(mailID)")
                return false
            }
        }
       
        return true
    }
    
    func getAllMails()->[Emails]{
        return self.AllEmails
    }

}

extension Database {
    
    func updateUser(user:  User) -> User?{
        emailAndUser[user.EmailID] = user
        return emailAndUser[user.EmailID]
    }

    func getUserDetails(emailId: String)->User?{
        return emailAndUser[emailId]
    }
    
    func displayAllTheData(){
        print(" -------------------------------------- ")
        for (key,value) in emailAndUser{
            print(key,value)
            print("     ")
        }
        print(" -------------------------------------- ")
    }
    
    
}
