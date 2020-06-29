//
//  Event.swift
//  ProLearn
//
//  Created by Prism Student on 2020-04-20.
//  Copyright © 2020 Francheseco. All rights reserved.
//

import Foundation
import UIKit
import os.log
class Event: NSObject, NSCoding, URLSessionTaskDelegate, XMLParserDelegate {
    //let articleImage : UIImage
    let title : String
    let eventDes: String
    let student: String
    let tutor: String
    let eventDate: Date
    let eventID: String
    
    var sharedEventCollection : EventCollection?
    
    

    //MARK: NSCoding functions

    struct PropertyKey {
        //static let articleImage = "articleImage"
        static let title = "title"
        static let eventDes = "articleDes"
        static let student = "student"
        static let tutor = "tutor"
        static let eventDate = "eventDate"
        static let eventID = "eventID"
    }

    func encode(with aCoder: NSCoder) {
        //aCoder.encode(articleImage, forKey: PropertyKey.articleImage)
        aCoder.encode(title, forKey: PropertyKey.title)
        aCoder.encode(eventDes, forKey: PropertyKey.eventDes)
        aCoder.encode(student, forKey: PropertyKey.student)
        aCoder.encode(tutor, forKey: PropertyKey.tutor)
        aCoder.encode(eventDate, forKey: PropertyKey.eventDate)
        aCoder.encode(eventID, forKey: PropertyKey.eventID)
    }
    required convenience init?(coder aDecoder: NSCoder) {

        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let titleDecoded = aDecoder.decodeObject(
            forKey: PropertyKey.title) as? String else {
                os_log("Unable to decode the event title.",
                       log: OSLog.default, type: .debug)
                return nil
        }
        
        //let imageDecoded = (aDecoder.decodeObject(forKey: PropertyKey.articleImage) as? UIImage)!
        let desDecoded = (aDecoder.decodeObject(forKey: PropertyKey.eventDes) as? String)!
        let studentDecoded = (aDecoder.decodeObject(forKey: PropertyKey.student) as? String)!
        let tutorDecoded = (aDecoder.decodeObject(forKey: PropertyKey.tutor) as? String)!
        let IDDecoded = (aDecoder.decodeObject(forKey: PropertyKey.eventID) as? String)!
        let dateDecoded = (aDecoder.decodeObject(forKey: PropertyKey.eventDate) as? Date)!
        self.init(title: titleDecoded, eventDes: desDecoded , student: studentDecoded, tutor: tutorDecoded, eventDate: dateDecoded, eventID: IDDecoded)
    }
    
    init?(title: String, eventDes: String, student: String, tutor: String, eventDate: Date, eventID: String) {
        self.title = title
        //self.articleImage = articleImage
        self.eventDes = eventDes
        self.student = student
        self.tutor = tutor
        self.eventDate = eventDate
        self.eventID = eventID
    } //init?
    
    func getDescription()->String {
        return self.eventDes
    }
    
    func getStudent()->String {
        return self.student
    }
    
    func getTutor()->String {
        return self.tutor
    }
    
    func getEventDate()->Date {
        return self.eventDate
    }
    
   // func returnImage()->UIImage {
   //     return self.articleImage
   // }
    
    func getTitle()->String {
        return self.title
    }
    
    func getEventID()->String {
        return self.eventID
    }
}
