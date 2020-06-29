//
//  SharedEventCollection.swift
//  ProLearn
//
//  Created by Prism Student on 2020-04-20.
//  Copyright © 2020 Francheseco. All rights reserved.
//

import Foundation


class SharedEventCollection {
    private static let instance = SharedEventCollection()
    
    private var eventcollection: EventCollection
    
    private init() {
        self.eventcollection = EventCollection()
    }
    
    public static func isEmpty()-> Bool {
        return SharedEventCollection.instance.eventcollection.isEmpty()
    }
    
    public static func numEvents()-> Int {
        return SharedEventCollection.instance.eventcollection.numEvents()
    }
    
    public static func getEventAt(index: Int)-> Event {
        return SharedEventCollection.instance.eventcollection.getEventAt(index: index)
    }
    
    public static func addEvent(event: Event) {
        SharedEventCollection.instance.eventcollection.addEvent(event: event)
    }
    
    public static func currentEvent()-> Event {
        SharedEventCollection.instance.eventcollection.currentEvent()
    }
    
    public static func setIndex(index: Int) {
        SharedEventCollection.instance.eventcollection.setIndex(index: index)
    }
    
    public static func removeEvent() {
        SharedEventCollection.instance.eventcollection.removeEvent()
    }
    
    public static func append(event: Event){
        SharedEventCollection.instance.eventcollection.addEvent(event: event)
        
    }
}
