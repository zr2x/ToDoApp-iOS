//
//  AddTaskViewModel.swift
//  ToDoApp
//
//  Created by Искандер Ситдиков on 17.11.2024.
//

import Foundation

protocol AddTaskViewModelProtocol {
    var onTaskSaved: (() -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
    
    func saveTask(id: UUID,
                  shortDescription: String,
                  fullDescription: String,
                  status: TaskStatus,
                  createdDate: Date)
}

final class AddTaskViewModelImp: AddTaskViewModelProtocol {

    var onTaskSaved: (() -> Void)?
    var onError: ((String) -> Void)?
    
    private let taskService: TaskRepositoryProtocol
    
    init(taskService: TaskRepositoryProtocol) {
        self.taskService = taskService
    }
    
    func saveTask(id: UUID,
                  shortDescription: String,
                  fullDescription: String,
                  status: TaskStatus,
                  createdDate: Date) {
        
        let task = TaskModel(id: id,
                             shortDescription: shortDescription,
                             fullDescription: fullDescription,
                             status: status,
                             createdDate: createdDate)
        
        taskService.addTask(task) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.onTaskSaved?()
                case .failure(let error):
                    self.onError?(error.localizedDescription)
                }
            }
        }
    }
}
