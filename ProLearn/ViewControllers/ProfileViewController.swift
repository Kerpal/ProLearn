//
//  ProfileViewController.swift
//  ProLearn
//
//  Created by Francheseco on 2020-04-19.
//  Copyright © 2020 Francheseco. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var profileName: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var email: String?
        //initialize db and user collection which matches the profile name
        let db = Firestore.firestore()
        db.collection("users").whereField("first_name", isEqualTo: profileName.text!).getDocuments { (querysnapshot, err) in
            if let err = err {
                print("error fetching users: \(err)")
            } else {
                
                
                //fetches all the documents which contain the profile name
                //Assumes names are unique, however only way to fetch field data was through a for loop
                for document in (querysnapshot?.documents)! {
                    
                    //TO-DO:
                    //must create a string for the below mailing fnc with the retrieved email
                    if let name = document.data()["email"] as? String {
                        email = name
                        print(email!)
                    }
                    
                    //otherwise something went wrong fetching the data
                    else{
                        print("Something went wrong fetching data")
                    }
                }
            }
        }
        
        
        // Get email based on profiles name (i.e. the label text)
    }
    
    @IBAction func emailButtonPressed(_ sender: Any) {
        //TO-DO:
        // change the URL(string:...) to the specific profile names' email as fetched from the didLoad() fnc. "mailto:" + email variable
        UIApplication.shared.open(URL(string:"mailto:example@email.com")! as URL, options: [:], completionHandler: nil)
    }
    

    
    //TO-DO:
    //test functionality of emailing on your phone, doesnt work on simulator as there's no mailing app.
}
