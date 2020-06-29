//
//  EventViewController.swift
//  ProLearn
//
//  Created by Prism Student on 2020-04-20.
//  Copyright © 2020 Francheseco. All rights reserved.
//

import UIKit
import EventKit

class EventViewController: UIViewController {
    
    
    @IBOutlet weak var classTitle: UILabel!
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var tutorName: UILabel!
    @IBOutlet weak var classDate: UILabel!
    @IBOutlet weak var classDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        classTitle.text = SharedEventCollection.currentEvent().getTitle()
        studentName.text = SharedEventCollection.currentEvent().getStudent()
        tutorName.text = SharedEventCollection.currentEvent().getTutor()
        let dateString = stringFromDate(SharedEventCollection.currentEvent().getEventDate())
        classDate.text = dateString
        classDescription.text = SharedEventCollection.currentEvent().getDescription()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Do any additional setup after loading the view.
        classTitle.text = SharedEventCollection.currentEvent().getTitle()
        studentName.text = SharedEventCollection.currentEvent().getStudent()
        tutorName.text = SharedEventCollection.currentEvent().getTutor()
        let dateString = stringFromDate(SharedEventCollection.currentEvent().getEventDate())
        classDate.text = dateString
        classDescription.text = SharedEventCollection.currentEvent().getDescription()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Do any additional setup after loading the view.
        classTitle.text = SharedEventCollection.currentEvent().getTitle()
        studentName.text = SharedEventCollection.currentEvent().getStudent()
        tutorName.text = SharedEventCollection.currentEvent().getTutor()
        let dateString = stringFromDate(SharedEventCollection.currentEvent().getEventDate())
        classDate.text = dateString
        classDescription.text = SharedEventCollection.currentEvent().getDescription()
    }
    
    @IBAction func AddBtnPressed(_ sender: Any) {
        let eventStore:EKEventStore = EKEventStore()
        eventStore.requestAccess(to: .event) {(granted, error) in
            if (granted) && (error == nil) {
                print("granted \(granted)")
                print("error \(error)")
                
                let event:EKEvent = EKEvent(eventStore: eventStore)
                event.title = SharedEventCollection.currentEvent().getTitle()
                event.startDate = SharedEventCollection.currentEvent().getEventDate()
                event.endDate = SharedEventCollection.currentEvent().getEventDate()
                event.notes = SharedEventCollection.currentEvent().getDescription()
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let error as NSError {
                    print("error: \(error)")
                }
                print("Event Saved")
            }
            else {
                print("error: \(error)")
            }
        }
    }
    
    func stringFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy HH:mm" //yyyy
        return formatter.string(from: date)
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
