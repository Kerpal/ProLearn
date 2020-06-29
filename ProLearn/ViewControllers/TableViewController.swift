//
//  TableViewController.swift
//  ProLearn
//
//  Created by Prism Student on 2020-04-20.
//  Copyright © 2020 Francheseco. All rights reserved.
//

import SwiftUI
import UIKit
import Foundation
import os.log

let simpleTableIdentifier = "reuseIdentifier"
var sharedEventCollection: EventCollection?

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var classTitle: UILabel!
        
    @IBOutlet weak var classDate: UILabel!
    
}

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var eventsTable: UITableView!
    
    var tableData: [Event]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        sharedEventCollection?.setIndex(index: 0)
        tableData = sharedEventCollection?.collection
        
        eventsTable.delegate = self
        eventsTable.dataSource = self
        
        while (sharedEventCollection?.ready == false) {
            
        }
        eventsTable.reloadData()
        print("events that should be on table: \(SharedEventCollection.numEvents())")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        tableData = sharedEventCollection?.collection
        eventsTable.reloadData()
        print("events that should be on table: \(SharedEventCollection.numEvents())")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableData = sharedEventCollection?.collection
        eventsTable.reloadData()
        print("events that should be on table: \(SharedEventCollection.numEvents())")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return SharedEventCollection.numEvents()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("making cells")
        var cell = tableView.dequeueReusableCell(withIdentifier: simpleTableIdentifier, for: indexPath) as? CustomCell
        if (cell == nil) {
            cell = CustomCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: simpleTableIdentifier) as CustomCell
            
        } // the cell has an image property, set it
         
     let currentClass = SharedEventCollection.getEventAt(index: indexPath.row)
        cell?.classTitle?.text = currentClass.getTitle()
        let dateString = stringFromDate(currentClass.getEventDate())
        cell?.classDate?.text = dateString
        return cell!
    }
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         print("row selected")
         tableView.deselectRow(at: indexPath, animated: true)
         
         SharedEventCollection.setIndex(index: indexPath.row)
         //performSegue(withIdentifier: segueID, sender: sharedArticleCollection?.currentArticle()())
     }
    
    
    func stringFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy HH:mm" //yyyy
        return formatter.string(from: date)
    }
    

    @IBAction func reloadTableButton(_ sender: Any) {
        eventsTable.reloadData()
    }
    
}
