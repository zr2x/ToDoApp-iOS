//
//  TaskViewModel.swift
//  ToDoApp
//
//  Created by Искандер Ситдиков on 16.11.2024.
//

import Foundation

protocol TaskViewModelProtocol {
    var tasks: [TaskModel] { get }
    var actionHandler: (TaskAction) -> Void { get set }
    var onTaskUpdated: (() -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
    
    func fetchTasks()
    func addTask(_ task: TaskModel)
    func updateTask(_ task: TaskModel)
    func deleteTask(_ task: TaskModel)
}

final class TaskViewModelImp: TaskViewModelProtocol {
    private let taskService: TaskRepositoryProtocol
    
    var tasks: [TaskModel] = [] {
        didSet {
            onTaskUpdated?()
        }
    }
    
    var actionHandler: (TaskAction) -> Void
    var onTaskUpdated: (() -> Void)?
    var onError: ((String) -> Void)?

    init(taskService: TaskRepositoryProtocol, actionHandler: @escaping (TaskAction) -> Void) {
        self.taskService = taskService
        self.actionHandler = actionHandler
    }
    
    func fetchTasks() {
        taskService.fetchTasks { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success(let fetchedTasks):
                    self.tasks = fetchedTasks
                case .failure(let error):
                    self.onError?(error.localizedDescription)
                }
            }
        }
    }
    
    func addTask(_ task: TaskModel) {
        taskService.addTask(task) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success:
                    self.fetchTasks()
                case .failure(let error):
                    self.onError?(error.localizedDescription)
                }
            }
        }
    }
    
    func updateTask(_ task: TaskModel) {
        taskService.updateTask(task) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success:
                    self.fetchTasks()
                case .failure(let error):
                    self.onError?(error.localizedDescription)
                }
            }
        }
    }
    
    func deleteTask(_ task: TaskModel) {
        taskService.removeTask(task) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success:
                    self.fetchTasks()
                case .failure(let error):
                    self.onError?(error.localizedDescription)
                }
            }
        }
    }
}
