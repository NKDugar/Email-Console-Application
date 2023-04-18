
protocol FolderContract {
    func addFolders(user:  User , folderName: String)->User?
    func moveMailToAnotherFolder(user: User  , folderName: String)->User?
    func validateFolder(user: User , folderName: String)->Bool
}

protocol DisplayContract {
    func displayListOfFolders(user: User)
    func displayMails(folderName: String)->Bool
}

protocol AuthenticationContract {
    func registerUser(user:  User)->Bool
    func loginUser(emailId emailID: String , password: String) -> User?
    func logoutUser()->Bool
}

protocol MailContract {
    func composeMail(email: Emails)-> Emails?
    func sendEmail(email: Emails)->User?
    func markAsFavourite(mailId: Int)
    func openMail(mailId: Int, folderName: String)->Bool
    func markAsRead(mailId: Int , folderName: String)
    func deleteMail( mailId: Int, folderName: String)
}

