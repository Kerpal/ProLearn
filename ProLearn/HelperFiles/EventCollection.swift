//
//  EventCollection.swift
//  ProLearn
//
//  Created by Prism Student on 2020-04-20.
//  Copyright © 2020 Francheseco. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class EventCollection: NSObject, NSCoding {
    var collection = [Event]()
    var current:Int = 0

    let collectionKey = "collectionKey"
    let currentKey = "currentKey"
    
    var ready = false

    // MARK: - NSCoding methods
    override init(){
        super.init()
        setup()
    }
    
    // adds all relevent classes from the database to the local collection
    func setup(){
        print("num events: \(numEvents())")
        
        
        var className: String?
        var classDes: String?
        var studentName: String?
        var tutorName: String?
        var classID: String?
        
        var dateString: String?
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        var date: Date?
        
        // check what type of user you are
        //var userType: String?
        

        var userType: String?
        userType = "Admin"

            
            // get the name of the current user
        //username may need to be change don testing
        var userName = "Elon musk"
        var firstName: String?
        var lastName: String?
        var email: String?
        
        email = Auth.auth().currentUser!.email
        print("User email: \(email)")
        
        //get user type
        let db = Firestore.firestore()
        // first_name and isEqualTo is explicitly getting elons email account below, may need to change it to get to work for firstName and lastName variablses
        db.collection("users").whereField("email", isEqualTo: email!).getDocuments { (querysnapshot, err) in
            if let err = err {
                print("error fetching users: \(err)")
                self.ready = true
            } else {
                for document in (querysnapshot?.documents)! {
                    //check if firstName and lastName variables
                    if let name = document.data()["first_name"] as? String {
                                         firstName = name
                                         print(firstName!)
                                     }
                                     

                    //otherwise something went wrong fetching the data
                    else{
                        print("Something went wrong fetching data")
                    }
                    
                    if let name = document.data()["last_name"] as? String {
                                         lastName = name
                                         print(lastName!)
                                     }
                                     

                    //otherwise something went wrong fetching the data
                    else{
                        print("Something went wrong fetching data")
                    }
                    
                    if let name = document.data()["userType"] as? String {
                                         userType = name
                                         print(userType!)
                                     }
                                     

                    //otherwise something went wrong fetching the data
                    else{
                        print("Something went wrong fetching data")
                    }
                }
                
                userName = firstName! + " " + lastName!
                print("Full name: \(userName)")
                
                    
                // the user is an admin so they can see all classes
                if userType == "Admin" {
                    db.collection("classes").getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                print("\(document.documentID) => \(document.data())")
                                className = document.data()["class_name"] as? String
                                classDes = document.data()["class_des"] as? String
                                studentName = document.data()["student"] as? String
                                tutorName = document.data()["tutor"] as? String
                                classID = document.documentID as? String
                                dateString = document.data()["date"] as? String // get date string from db
                                date = formatter.date(from: dateString!) // convert date string to date object
                                print("class: \(className) \(classDes)\(studentName) \(tutorName) \(classID) \(dateString)")
                                self.collection.append(Event(title: className!, eventDes: classDes!, student: studentName!, tutor: tutorName!, eventDate: date!, eventID: classID!)!)
                                print("num events: \(self.numEvents())")
                                
                            }
                        }
                    }
                }
                    
                // the user is a tutor so they see all classes where they are a tutor
                else if userType == "Tutor" {
                    db.collection("classes").whereField("tutor", isEqualTo: userName)
                        .getDocuments() { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                print("user is a tutor")
                                for document in querySnapshot!.documents {
                                    print("\(document.documentID) => \(document.data())")
                                    className = document.data()["class_name"] as? String
                                    classDes = document.data()["class_des"] as? String
                                    studentName = document.data()["student"] as? String
                                    tutorName = document.data()["tutor"] as? String
                                    classID = document.documentID as? String
                                    dateString = document.data()["date"] as? String // get date string from db
                                    date = formatter.date(from: dateString!) // convert date string to date object
                                    
                                    self.collection.append(Event(title: className!, eventDes: classDes!, student: studentName!, tutor: tutorName!, eventDate: date!, eventID: classID!)!)
                                }
                            }
                    }
                }
                    
                // the user is a student so they see all classes where they are a student
                else if userType == "Student" {
                    db.collection("classes").whereField("student", isEqualTo: userName)
                        .getDocuments() { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                for document in querySnapshot!.documents {
                                    print("\(document.documentID) => \(document.data())")
                                    className = document.data()["class_name"] as? String
                                    classDes = document.data()["class_des"] as? String
                                    studentName = document.data()["student"] as? String
                                    tutorName = document.data()["tutor"] as? String
                                    classID = document.documentID
                                    dateString = document.data()["date"] as? String // get date string from db
                                    date = formatter.date(from: dateString!) // convert date string to date object
                                    
                                    self.collection.append(Event(title: className!, eventDes: classDes!, student: studentName!, tutor: tutorName!, eventDate: date!, eventID: classID!)!)
                                }
                            }
                    }
                                        
                }
                
                print("num events: \(self.numEvents())")
                self.ready = true
            }
        }
        
    }
    
    required convenience init?(coder decoder: NSCoder) {
        self.init()
        collection = (decoder.decodeObject(forKey: collectionKey) as? [Event])!
        current = (decoder.decodeInteger(forKey: currentKey))
    }

    func encode(with acoder: NSCoder) {
        acoder.encode(collection, forKey: collectionKey)
        acoder.encode(current, forKey: currentKey)
    }

     func currentEvent() -> Event {
        let event = collection[self.current]
        return event
     }
    
    func getIndex()-> Int {
        return self.current
    }
    
    func setIndex(index: Int) {
        current = index
    }
    
    func nextEvent() {
        current += 1
        if (self.current == self.collection.count) {
            current = 0
        }
    }
    
    func prevEvent() {
        current -= 1
        if (self.current < 0) {
            current = self.collection.count
        }
    }
    
    func numEvents()-> Int {
        return collection.count
    }
    
    func isEmpty()-> Bool {
        return collection.isEmpty
    }
    
    func getEventAt(index: Int)-> Event {
        if !collection.isEmpty && index >= 0 && index <= collection.count
        {
            return collection[index]
        }
        else
        {
            fatalError("ERROR: Index out of range")
        }
    }
    
    func addEvent(event: Event) {
        collection.append(event)
    }
    
    func removeEvent() {
        if (self.current == self.collection.count - 1) {
            collection.remove(at: current)
            self.current = 0
        }
        else {
            collection.remove(at: current)
        }
    }
    
    
    // helper functions for setup
    
    
}
