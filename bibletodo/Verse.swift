//
//  Verse.swift
//  bibletodo
//
//  Created by John on 26.05.25.
//
import Foundation
import SwiftData

struct Verse: Identifiable, Codable {
    let id = UUID()
    var text: String
    var refernce: String
}
