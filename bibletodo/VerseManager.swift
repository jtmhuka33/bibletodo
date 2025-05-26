//
//  VerseManager.swift
//  bibletodo
//
//  Created by John on 26.05.25.
//

import Foundation

class VerseManager: ObservableObject{
    @Published var currentVerse: Verse?
    private var allVerses: [Verse] = []
    
    init() {
        loadVerses()
        selectRandomVerse()
    }
    
    private func loadVerses () {
        guard let url = Bundle.main.url(forResource: "verses", withExtension: "json") else {
            print("verses.json file not found")
            return
        }
        do {
            let data = try Data(contentsOf: url)
            allVerses = try JSONDecoder().decode([Verse].self, from: data)
        } catch {
            print("Error loading verse:  \(error)")
        }
    }
    
    func selectRandomVerse() {
        guard !allVerses.isEmpty else { return }
        currentVerse = allVerses.randomElement()
    }
}
