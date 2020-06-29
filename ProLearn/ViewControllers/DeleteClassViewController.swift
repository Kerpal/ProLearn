//
//  DeleteClassViewController.swift
//  ProLearn
//
//  Created by Prism Student on 2020-04-20.
//  Copyright © 2020 Francheseco. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class DeleteClassViewController: UIViewController {

    @IBOutlet weak var reasonTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func cancelClass(_ sender: Any) {
        // check if the user is an admin or not
        
        var userType: String?
        //let userInfo = Auth.auth().currentUser?.providerData[indexPath.row]
        //if your just trying to get the current user the code is: let currentUser = Auth.auth().currentUser
        
        
        
        //get user type
        let db = Firestore.firestore()
        db.collection("users").whereField("uid", isEqualTo: Auth.auth().currentUser!.uid as String).getDocuments { (querysnapshot, err) in
            if let err = err {
                print("error fetching users: \(err)")
            } else {

                for document in (querysnapshot?.documents)! {

                    if let name = document.data()["userType"] as? String {
                        userType = name
                        print(userType!)
                    }

                    //otherwise something went wrong fetching the data
                    else{
                        print("Something went wrong fetching data")
                    }
                }
                
                // the user is an admin so they can delete the class
                if userType == "Admin" {
                    
                    // remove the class from the database
                    //let db = Firestore.firestore()
                    db.collection("classes").document(SharedEventCollection.currentEvent().getEventID()).delete() { err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("Document successfully removed!")
                        }
                    }
                    
                    // remove the event from local collection
                    SharedEventCollection.removeEvent()
                    
                    self.deletedAlert()
                    
                    //transition to main screen
                    self.transitionToMain()
                    
                }
                    
                // the user is not an admin so they can only make a request to the admin
                else {
                    // create a new request
                    UIApplication.shared.open(URL(string:"mailto:prolearnadm1n@gmail.com")! as URL, options: [:], completionHandler: nil)
                    self.requestAlert()
                }
                
                // go to the main screen
                //self.transitionToMain()
            }
        }
        
    }
    
    // alert if class is added
    func deletedAlert() {
        let alert = UIAlertController(title: "Class Removed", message: "The class has been removed", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //alert if class is sent as request
    func requestAlert() {
        let alert = UIAlertController(title: "Cancelation Requested", message: "A request has been sent to the admin", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //transition to main screen
    func transitionToMain(){
        let homeVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeView) as? TableViewController
        
        view.window?.rootViewController = homeVC
        
        view.window?.makeKeyAndVisible()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
