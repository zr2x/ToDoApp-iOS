//
//  TaskError.swift
//  ToDoApp
//
//  Created by Искандер Ситдиков on 16.11.2024.
//

import Foundation

enum TaskError: Error {
    case coreDataSaveFailed
    case taskNotFound
    case deleteTaskFailed
    case fetchTasksFailed
    case unknownError
    case custom(message: String)
    
    var localizedDescription: String {
        switch self {
        case .coreDataSaveFailed:
            return "error_core_data_save_failed".localized
        case .deleteTaskFailed:
            return "error_delete_failed".localized
        case .fetchTasksFailed:
            return "error_fetch_tasks_failed".localized
        case .taskNotFound:
            return "error_task_not_found".localized
        case .unknownError:
            return "error_unknown_title".localized
        case .custom(let message):
            return message
        }
    }
}
