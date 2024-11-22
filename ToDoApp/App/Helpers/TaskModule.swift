//
//  TaskModule.swift
//  ToDoApp
//
//  Created by Искандер Ситдиков on 18.11.2024.
//

import UIKit

enum TaskAction {

    case add
    case select(task: TaskModel)
    case showError
}

final class TaskModule {
    
    /// Creating a TaskViewController with hidden implementation
    /// - Parameters:
    ///   - taskRepository: database service
    ///   - actionHandler: user action handler
    /// - Returns: returns TaskViewController
    static func build(taskRepository: TaskRepositoryProtocol, actionHandler: @escaping (TaskAction) -> Void) -> UIViewController {
        let viewModel = TaskViewModelImp(taskService: taskRepository, actionHandler: actionHandler)
        let vc = TaskViewController(viewModel: viewModel)
        return vc
    }
}
