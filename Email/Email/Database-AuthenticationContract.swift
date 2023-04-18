//
//  Database-AuthenticationContract.swift
//  Email
//
//  Created by naveen-pt6301 on 17/02/23.
//

import Foundation
import CryptoKit

extension Database: AuthenticationContract{
    
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
