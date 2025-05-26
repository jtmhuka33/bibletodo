//
//  Item.swift
//  bibletodo
//
//  Created by John on 15.05.25.
//

import Foundation
import SwiftData

//This is like a model in laravel
/**
 Codable - allows me to save and load tasks from storage
 Identifiable - tells swiftUI that it can identify each unique class. This is basically like giving a key to component in react.
 */
struct Task: Identifiable, Codable {
    let id = UUID() //this is a unique identifier for each task so the app can identify them.
    var title: String
    var isComplete: Bool = false
    var createdDate: Date = Date()
    
    //this is a computed property to format the date into a human readable format
    var formattedDate:String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: createdDate)
    }
}
