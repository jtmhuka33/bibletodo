import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TaskViewModel()
    @StateObject private var verseManager = VerseManager()
    @State private var showingAddTask = false
    @State private var newTaskTitle = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background color
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Bible verse section at the top
                    bibleVerseSection
                    
                    // Main task list
                    taskListSection
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddTask = true }) {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
            }
            .navigationTitle("Hey, John")
            .sheet(isPresented: $showingAddTask) {
                addTaskSheet
            }
        }
    }

    
    // Bible verse display with elegant styling
    private var bibleVerseSection: some View {
        VStack(spacing: 20){
            if let verse = verseManager.currentVerse {
                VStack(alignment: .center, spacing: 10){ // Add alignment: .top
                    VStack(spacing: 10){
                        Text(verse.text)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Text(verse.reference)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    Button(action: { reloadVerse() }){
                        Image(systemName: "arrow.counterclockwise")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }.padding()
            } else {
                Text("Loading verse...")
            }
        }
    }
    
    // Scrollable list of tasks organized by date
    private var taskListSection: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(sortedDateKeys, id: \.self) { dateKey in
                    if let tasksForDate = viewModel.tasksByDate[dateKey] {
                        taskSectionView(for: dateKey, tasks: tasksForDate)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 80) // Space for floating action button
        }
    }
    
    // Individual date section with tasks
    private func taskSectionView(for date: String, tasks: [Task]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(date)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            ForEach(tasks) { task in
                TaskRowView(task: task, viewModel: viewModel)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 4)
    }
    
    // Helper to sort dates (newest first)
    private var sortedDateKeys: [String] {
        viewModel.tasksByDate.keys.sorted { date1, date2 in
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            let d1 = formatter.date(from: date1) ?? Date()
            let d2 = formatter.date(from: date2) ?? Date()
            return d1 > d2
        }
    }
    
    // Modal sheet for adding new tasks
    private var addTaskSheet: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("What needs to be done?", text: $newTaskTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.body)
                
                Spacer()
            }
            .padding()
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        showingAddTask = false
                        newTaskTitle = ""
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        if !newTaskTitle.isEmpty {
                            viewModel.addTask(title: newTaskTitle)
                            showingAddTask = false
                            newTaskTitle = ""
                        }
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    private func reloadVerse() {
        verseManager.selectRandomVerse()
    }
}
