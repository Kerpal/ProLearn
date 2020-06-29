//
//  SignUpViewController.swift
//  ProLearn
//
//  Created by Francheseco on 2020-04-19.
//  Copyright © 2020 Francheseco. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var dropdownButton: UIButton!
    
    @IBOutlet var accountTypes: [UIButton]!
    
    @IBOutlet weak var fNameTextField: UITextField!
    @IBOutlet weak var lNameTextField: UITextField!

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    

    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var userType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.alpha = 0
        
    }
    @IBAction func signUpPressed(_ sender: Any) {
        
        //validate text fields
        let error = validateFields()
        if error != nil{
            errorLabel.text = error!
            errorLabel.alpha = 1
        }
        //create user
        else{
            
            let firstName = fNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email,  password: password) { (result, err) in
                //check for errors and display error msg
                if err != nil {
                    // there was an error creating user
                    self.errorLabel.text = "Error Creating User"
                    self.errorLabel.alpha = 1
                }
                else{
                    // user was created successfully, store fName and lName
                    let db = Firestore.firestore()
                    //adds user to Firebase db "users" collection. Right now writing is allowed from any person that has access to the db without need for authenticatio (shouldnt be an issue)
                    db.collection("users").addDocument(data: [
                        "first_name": firstName,
                        "last_name": lastName,
                        "userType": self.userType!,
                        "email": email,
                        "uid": result!.user.uid
                    ]) { (error) in
                        // IF fname and lname couldnt be stored for some reason show an error msg
                        if error != nil {
                            self.errorLabel.text = "User first name and last name couldnt be saved on database"
                            self.errorLabel.alpha = 1
                            
                        }
                    }
                    //transition to main screen
                    self.transitionToMain()
                }
            }
        }
        //transition to main page
    }
    
    // check fields validate if correct. if correct method returns nil. otherwise return error message
    func validateFields() -> String? {
        //check that all fields are filled
        
        if fNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            userType == nil{
            return "Please fill in fields."
        }
        
        //if everythings filled out then return nil
        return nil
    }
    
    //transition to main screen
    func transitionToMain(){
        let homeVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeView) as? TableViewController
        
        view.window?.rootViewController = homeVC
        
        view.window?.makeKeyAndVisible()
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        let loginVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.loginView) as? ViewController
        
        view.window?.rootViewController = loginVC
        
        view.window?.makeKeyAndVisible()
        
    }
    
    
    //Account Type Selection
    
    @IBAction func selectAccount(_ sender: Any) {
        
        accountTypes.forEach {
            (account) in UIView.animate(withDuration: 0.3, animations: {account.isHidden = !account.isHidden
                
                self.dropdownButton.isHidden = !self.dropdownButton.isHidden
                
                self.view.layoutIfNeeded()
            })
        }
        
    
    }
    @IBAction func dropdownPressed(_ sender: Any) {
        
        accountTypes.forEach {
            (account) in UIView.animate(withDuration: 0.3, animations: {account.isHidden = !account.isHidden
                
                self.dropdownButton.isHidden = !self.dropdownButton.isHidden
                
                self.view.layoutIfNeeded()
            })
        }
    }
    
    enum Accounts: String{
        case student = "Student"
        case tutor = "Tutor"
        case admin = "Admin"
    }
    
    @IBAction func accountChosen(_ sender: UIButton){
        guard let title = sender.currentTitle else {
            return
        }
        
        userType = accType(account:title, sender: sender)
        
        
        
        
    }
    
    func accType(account: String, sender: UIButton)->String?{
        guard let accType = Accounts(rawValue: account) else {
            return nil
        }
        switch accType {
        case .student:
            sender.setTitleColor(.green, for: .normal)
            return "Student"
        case .tutor:
            sender.setTitleColor(.green, for: .normal)
            return "Tutor"
        case .admin:
            sender.setTitleColor(.green, for: .normal)
            return "Admin"
        }
    }
}
