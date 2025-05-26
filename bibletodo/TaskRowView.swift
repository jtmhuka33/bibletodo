//
//  TaskRowView.swift
//  bibletodo
//
//  Created by John on 23.05.25.
//
import SwiftUI
import Foundation
import Combine

struct TaskRowView: View {
    let task: Task
    let viewModel: TaskViewModel
    
    var body: some View {
        HStack {
            // Completion toggle button
            Button(action: { viewModel.toggleTaskCompletion(task) }) {
                Image(systemName: task.isComplete ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(task.isComplete ? .green : .gray)
            }
            
            // Task title with strikethrough when completed
            Text(task.title)
                .font(.body)
                .strikethrough(task.isComplete)
                .foregroundColor(task.isComplete ? .secondary : .primary)
            
            Spacer()
            
            // Delete button
            Button(action: { viewModel.deleteTask(task) }) {
                Image(systemName: "trash")
                    .font(.body)
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle()) // Makes entire row tappable
    }
}
