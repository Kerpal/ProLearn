//
//  AddClassViewController.swift
//  ProLearn
//
//  Created by Prism Student on 2020-04-20.
//  Copyright © 2020 Francheseco. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class AddClassViewController: UIViewController {

    @IBOutlet weak var className: UITextField!
    @IBOutlet weak var studentName: UITextField!
    @IBOutlet weak var tutorName: UITextField!
    @IBOutlet weak var classDate: UIDatePicker!
    @IBOutlet weak var classDetails: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addClassBtn(_ sender: Any) {
        //validate text fields
        var error = validateFields()
        print("Fields for adding: \(error)")
        if error != nil{
            errorLabel.text = error!
            errorLabel.alpha = 1
        }
            
        //text fields are filled out, check if user is admin
        else{
            
            var userType: String?

            //if let type = currentUser.data()["userType"] as? String {userType = type print(userType!)
                
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
                    
                    // the user is an admin so they can add the class
                    if userType == "Admin" {
                        print("goes into if")
                        // make a string for the date
                        let dateString = self.stringFromDate(self.classDate.date)
                        
                        // make a string for the ID
                        let classID = self.randomString(length: 20)
                        
                        // add the event to local collection
                        SharedEventCollection.append(event: Event(title: self.className.text!, eventDes: self.classDetails.text!, student: self.studentName.text!, tutor: self.tutorName.text!, eventDate: self.classDate.date, eventID: classID)!)
                        
                        // add the class from the database
                        //adds class to Firebase db "class" collection. Right now writing is allowed from any person that has access to the db without need for authenticatio (shouldnt be an issue)
                        db.collection("classes").document(classID).setData([
                            "class_name": self.className.text!,
                            "class_des": self.classDetails.text!,
                            "student": self.studentName.text!,
                            "tutor": self.tutorName.text!,
                            "date": dateString
                        ]) { (error) in
                            // IF fname and lname couldnt be stored for some reason show an error msg
                            if error != nil {
                                self.errorLabel.text = "Class could not be saved to database"
                                self.errorLabel.alpha = 1
                                
                            }
                        }
                        self.addedAlert()
                        
                        //transition to main screen
                        self.transitionToMain()
                    }
                    // the user is not an admin so they can only make a request to the admin
                    else {
                        // create a new request
                        UIApplication.shared.open(URL(string:"mailto:prolearnadm1n@gmail.com")! as URL, options: [:], completionHandler: nil)
                        self.requestAlert()
                    }
                    
                    //transition to main screen
                    //self.transitionToMain()
                }
            }
            
        }
        
    
        
    }
    
    // check fields validate if correct. if correct method returns nil. otherwise return error message
    func validateFields() -> String? {
        //check that all fields are filled
        
        if className.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || studentName.text?.trimmingCharacters(in:.whitespacesAndNewlines) == "" ||
            tutorName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            classDetails.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            classDate == nil{
                return "Please fill in fields."
        }
        
        //if everythings filled out then return nil
        return nil
    }
    
    // turn the date into a string
    func stringFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter.string(from: date)
    }
    
    // creates a random string that can be used for the ID of the class document
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    // alert if class is added
    func addedAlert() {
        let alert = UIAlertController(title: "Class Scheduled", message: "The class has been scheduled", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //alert if class is sent as request
    func requestAlert() {
        let alert = UIAlertController(title: "Class Requested", message: "A request has been sent to the admin", preferredStyle: .alert)
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
