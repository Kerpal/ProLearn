//
//  ViewController.swift
//  ProLearn
//
//  Created by Francheseco on 2020-04-19.
//  Copyright © 2020 Francheseco. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.alpha = 0
        
    }
    

    
    @IBAction func loginButtonPressed(_ sender: Any) {
        //validate fields
        let err = validateFields()
        
        if err == nil{
            //Sign in user
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                //Show error
                if error != nil {
                    self.errorLabel.text = error!.localizedDescription
                    self.errorLabel.alpha = 1
                }
                //go to main page
                else{
                    let homeVC = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeView) as? TableViewController
                    
                    self.view.window?.rootViewController = homeVC
                    
                    self.view.window?.makeKeyAndVisible()
                }
            }
        }
        else{
            errorLabel.text = err
            errorLabel.alpha = 1
        }
        
        
        
    }
    
    func validateFields() -> String? {
        //check that all fields are filled
        
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in fields."
        }
        
        //if everythings filled out then return nil
        return nil
    }
    
}

