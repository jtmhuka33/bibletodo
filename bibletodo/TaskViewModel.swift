//
//  TaskViewModel.swift
//  bibletodo
//
//  Created by John on 23.05.25.
//

import Foundation //TODO: What does this do?
import Combine //TODO: What does this do?

/**
 ObservableObject allows swift UI to watch for changes
 */
class TaskViewModel: ObservableObject {
    // @Published tells swiftUI to update the UI when these variables change
    @Published var tasks: [Task] = []
    @Published var bibleVerse: String = "Loading inspirational verse"
    
    //TODO: what does this do?
    init(){
        loadTasks()
        fetchBibleVerse()
    }
    
    var tasksByDate: [String: [Task]]{
        Dictionary(grouping: tasks){
            task in task.formattedDate
        }
    }
    
    func toggleTaskCompletion(_ task: Task){
        if let index = tasks.firstIndex(where: {$0.id == task.id}){
            tasks[index].isComplete.toggle()
            saveTasks()
        }
    }
    
    func addTask(title:String){
        let newTask = Task(title: title)
        tasks.append(newTask)
        saveTasks()
    }
    
    func deleteTask(_ task: Task) {
        tasks.removeAll {$0.id == task.id}
        saveTasks()
    }
    
    /**
     
     */
    private func saveTasks(){
        if let data = try? JSONEncoder().encode(tasks){
            UserDefaults.standard.set(data, forKey: "savedTasks")
        }
    }
    
    /**
      TODO: analyse this code line for line and understand whats happening
     */
    func fetchBibleVerse() {
            guard let url = URL(string: "https://bible-api.com/random") else { return }
            
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else { return }
                
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let text = json["text"] as? String,
                   let reference = json["reference"] as? String {
                    
                    DispatchQueue.main.async {
                        self?.bibleVerse = "\"\(text)\" - \(reference)"
                    }
                }
            }.resume()
        }
    
    func loadTasks(){
        if let data = UserDefaults.standard.data(forKey: "savedTasks"),
           let decodedTasks = try? JSONDecoder().decode([Task].self, from: data) {
            tasks = decodedTasks
        }
    }
}

