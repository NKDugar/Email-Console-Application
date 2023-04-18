//
//  main.swift
//  Email
//
//  Created by naveen-pt6301 on 14/02/23.
//

import Foundation

 private var useCase = userUseCase()
 var currentUser = User()
 var currentEmail = Emails()
var currentFolder = ""
var currentMailId = 0


var acc1 = User(Name: "naveen",  EmailID: "naveen@gmail.com" , password: "12345")
var acc2 = User(Name: "guhan", EmailID: "guhan@gmail.com" , password: "12345")
var acc3 = User(Name: "deepak", EmailID: "deepak@gmail.com", password: "12345")
var acc4 = User(Name: "arun", EmailID: "arun@gmail.com", password: "12345")

let result1 = useCase.registerUser(user: acc1)
let result2 = useCase.registerUser(user: acc2)
let result3 = useCase.registerUser(user: acc3)
let result4 = useCase.registerUser(user: acc4)


while true{
    
    func registerAndLoginPage(){
        
        print("welcome to email ")
        print("1. register")
        print("2. login")
        
        let selectedOption = readLine()
        let selectedoption = Int(selectedOption!)
        print("selected option: ",selectedoption ?? -1)
        switch selectedoption{
        case 1:
           
            print("register : ")
            print("enter userName: ",terminator: " ")
            let userName = readLine()!
            print("enter emailID: ",terminator: " ")
            let emailID = readLine()!
            print("enter password: ",terminator: " ")
            let password = readLine()!
            print(String(repeating: "-", count: 30))
            let newUser = User(Name: userName, EmailID: emailID, password: password)
            if useCase.registerUser(user: newUser){
                print("user registration successfull ")
            }
        case 2:
            print(String(repeating: "-", count: 30))
            print("LOGIN - ")
            
            print("emailID: ",terminator: " ")
            let emailID = readLine()!
            print("password: ",terminator: " ")
            let password = readLine()!
            print(String(repeating: "-", count: 30))
            guard let loginUser = useCase.loginUser(emailId: emailID, password: password)else{
                print(errorHandling.failedRetrieval)
                return
            }
            print("LOGIN successfull : \(String(describing: loginUser.EmailID))")
            print(String(repeating: "-", count: 30))
            
            currentUser = loginUser
            afterLogin(user: currentUser)
            
        default:
            print("invalid option entered")
        }
    }
    
    func afterLogin(user:  User){
        print(String(repeating: "-", count: 40))
        print("1. compose mail")
        print("2. inboxMails")
        print("3. sentMails")
        print("4. addFolders")
        print("5. listOffolders")
        print("6. openFolder")
        print("7. logout")
        
        let optionSelected = readLine()!
        let optionselected = Int(optionSelected)
        print(String(repeating: "-", count: 30))
        
        switch optionselected{
        case 1:
            print("--------  composing a email -------")
            composeMailView(user: currentUser)
            print(currentUser.EmailID , " currentemailId ")
            afterLogin(user: currentUser)
        case 2:
            print("----------  inbox -  --------")
            currentFolder = "Inbox"
            useCase.displayMails(folderName: currentFolder)
            openingFolder()
        case 3:
            print("------  sentMails folder ---------")
            currentFolder = "Sent"
            useCase.displayMails(folderName: currentFolder)
            openingFolder()
        case 4:
            print("----- adding folders -----")
            print("enter the name of the folder: ",terminator: " ")
            let foldername = readLine()
            guard let currentUser = useCase.addFolders(user: user, folderName: foldername ?? "default") else {
                print("the current user is nil")
                return
            }
            afterLogin(user: currentUser)
        case 5:
            useCase.displayListOfFolders(user: currentUser)
            afterLogin(user: currentUser)
        case 6:
            print("open a folder")
            useCase.displayListOfFolders(user: currentUser)
            print("enter the exact name of the folder you want to open: ",terminator: " ")
            let folderName = readLine() ?? "none"
//            currentFolder = folderName
            if useCase.displayMails(folderName: folderName){
                openingFolder()
            }else{
                print(currentFolder , " 000 ")
                afterLogin(user: currentUser)
                
            }
            
        case 7:
            print(" ----- logout ------")
            print("emailId: \(currentUser.EmailID)")
            _ = useCase.logoutUser()
            registerAndLoginPage()
            
        case 10:
            print("displaying user info: ")
            Database.shared.displayAllTheData()
            print(currentUser.EmailID)
            afterLogin(user: currentUser)
        default:
            print("----------- invalid number entered -----------")
        }
    }
    
    func composeMailView(user:   User){
        print(String(repeating: "-", count: 30))
        print("toAddress: ",terminator: " ")
        let toAddress = readLine()!
        print("enter CC : ",terminator: " ")
        let cc = readLine()?.components(separatedBy: ",")
        print("subject : ",terminator: " ")
        let subject = readLine()!
        print("body  : ",terminator: " ")
        let body = readLine()!
        
        var trimmedCc: [String] = []
        if let cc = cc {
            trimmedCc = cc.map { $0.trimmingCharacters(in: .whitespaces) }
        } else {
            print("cc is nil")
        }
        
        let isRead = false
        let isFavourite = false
        print(String(repeating: "-", count: 30))
        let newEmail = Emails(toAddress: toAddress, fromAddress: user.EmailID, subject: subject , body: body, cc:  trimmedCc, isRead: isRead, isFavourite: isFavourite )
        let mail = useCase.composeMail(email: newEmail)
        if mail == nil {
            print("mail composing failed")
            print(String(repeating: "-", count: 30))
            afterLogin(user: user)
        }else{
            afterComposition( email: mail!)
        }
        
    }
    
    func openingFolder (){
        print(String(repeating: "-", count: 30))
        print("1. openMail")
        print("2. deleteMail")
        print("3. back")
        print("4. markAsRead")
        print("selected option: ",terminator: " ")
        
        let optionSelected = readLine()!
        let optionselected = Int(optionSelected)
        print(String(repeating: "-", count: 30))
        switch optionselected {
        case 1:
            print(" open mail in \(currentFolder)")
            let emailId = gettingMailID()
            if useCase.openMail(mailId: emailId, folderName: currentFolder){
                //            have to change this here
                            openingMail()
            }else{
                openingFolder()
            }

        case 2:
            print("delete mail in \(currentFolder)")
            let emailId = gettingMailID()
            useCase.deleteMail(mailId: emailId, folderName: currentFolder)
            openingFolder()
//        case 3:
//            copyToAnotherFolder(email: currentEmail)
        case 3:
            print("goback")
            afterLogin(user: currentUser)
        case 4:
            print("mark as read")
            let emailId = gettingMailID()
            useCase.markAsRead(mailId: emailId, folderName: currentFolder)
            
        default:
            print(" invalid number ")
        }
        
    }
    
    func gettingMailID()->Int{
        print("enter the mailID:  ",terminator: " ")
        let optionSelected = readLine()!
        let optionselected = Int(optionSelected)
        print(String(repeating: "-", count: 30))
        return optionselected ?? -1
    }
    
    func afterComposition(email: Emails){
        print(String(repeating: "-", count: 30))
        print("1. send")
        print("2. cancel")
        print("selected option: ",terminator: " ")
        let optionSelected = readLine()!
        let optionselected = Int(optionSelected)
        print(String(repeating: "-", count: 30))
        switch optionselected{
        case 1:
            print("--------  send -------")
            currentEmail = email
            currentUser = useCase.sendEmail(email: email)!
            afterLogin(user: currentUser)
        case 2:
            print("----------  cancel   --------")
            afterLogin(user: currentUser)
        default:
            print("-------- invalid number entered -------")
            afterLogin(user: currentUser)
        }
    }
    
    func moveToAnotherFolder(email: Emails){
        print("--------move a mail to another folder----------")
        useCase.displayListOfFolders(user: currentUser)
        print("enter the name of the folder:  ",terminator: " ")
        let nameOfFolder = readLine()!
        currentUser = useCase.moveMailToAnotherFolder(user: currentUser , folderName: nameOfFolder)!
        afterLogin(user: currentUser)
    }
    
    func openingMail(){
        print("after open mail ")
        print("1. markAsFavourite")
        print("2. moveToAnotherFolder")
//        print("2. reply")
        print("3. delete")
        print("4. back")
        let input = readLine()
        guard let input = input else{
            print("nothing entered ")
            return
        }
        let input1 = Int(input) ?? -1
        switch input1 {
        case 1:
            print("mark as fav")
            let emailId = gettingMailID()
            useCase.markAsFavourite(mailId: currentMailId)
            openingFolder()
        case 2:
            print("moveToAnotherFolder")
            let folderName = getFolderName()
            currentUser = useCase.moveMailToAnotherFolder(user: currentUser , folderName: folderName)!
            openingFolder()
        case 3:
            print("delete mail in \(currentFolder)")
            let emailId = gettingMailID()
            useCase.deleteMail(mailId: emailId, folderName: currentFolder)
            openingFolder()
        case 4:
            print("back")
            openingFolder()
        default:
            print("invalid number entered")
        }
        
    }
    
    func getFolderName()->String{
        print("enter the folder name: ",terminator: " ")
        let input = readLine()!
        return input
    }
    
    
    _ = useCase.logoutUser()
    registerAndLoginPage()
    
}
