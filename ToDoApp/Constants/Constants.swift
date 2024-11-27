//
//  Constants.swift
//  ToDoApp
//
//  Created by Искандер Ситдиков on 27.11.2024.
//

import Foundation

struct Constants {
    enum Placeholder {
        static let shortDescription = "short_description_placeholder".localized
        static let fullDescription = "full_description_placeholder".localized
    }
    
    enum Validation {
        static let fullDescriptionEmpty = "full_description_empty_title".localized
        static let shortDescriptionEmpty = "error_message".localized
    }
    
    enum Button {
        static let save = "save_button_title".localized
        static let cancel = "cancel_title".localized
    }
    
    enum Error {
        static let genericTitle = "error_title".localized
        static let unknown = "error_unknown_title".localized
        static let coreDataSaveFailed = "error_core_data_save_failed".localized
        static let taskNotFound = "error_task_not_found".localized
        static let deleteFailed = "error_delete_failed".localized
        static let fetchFailed = "error_fetch_task_failed".localized
    }
    
    enum TaskStatus {
        static let new = "task_status_new".localized
        static let inProgress = "task_status_in_progress".localized
        static let done = "task_status_done".localized
    }
    
    enum Task {
        static let finish = "task_finish".localized
        static let created = "task_created".localized
        static let status = "task_status".localized
        static let takeInProgress = "task_take_in_progress".localized
        static let changeStatus = "task_change_status".localized
        static let alreadyDone = "task_already_done".localized
    }
}
