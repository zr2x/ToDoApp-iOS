//
//  Task.swift
//  ToDoApp
//
//  Created by Искандер Ситдиков on 16.11.2024.
//

import Foundation

enum TaskStatus: String {
    case new = "task_status_new"
    case inProgress = "task_status_in_progress"
    case done = "task_status_done"
    
    var localized: String {
        rawValue.localized
    }
}

struct TaskModel {
    let id: UUID
    let shortDescription: String
    let fullDescription: String?
    var status: TaskStatus
    let createdDate: Date
    
    var canDelete: Bool {
        return status != .inProgress && status != .done
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        formatter.locale = Locale.current
        return formatter.string(from: createdDate)
    }
}
