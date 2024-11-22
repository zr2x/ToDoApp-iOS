//
//  TaskRepository.swift
//  ToDoApp
//
//  Created by Искандер Ситдиков on 16.11.2024.
//

import Foundation
import CoreData

protocol TaskRepositoryProtocol {
    func fetchTasks(completion: @escaping ((Result<[TaskModel], TaskError>) -> Void))
    func addTask(_ task: TaskModel, completion: @escaping ((Result<Bool, TaskError>) -> Void))
    func removeTask(_ task: TaskModel, completion: @escaping ((Result<Bool, TaskError>) -> Void))
    func updateTask(_ task: TaskModel, completion: @escaping ((Result<Bool, TaskError>) -> Void))
}

final class TaskRepositoryImp: TaskRepositoryProtocol {
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    func fetchTasks(completion: @escaping ((Result<[TaskModel], TaskError>) -> Void)) {
        coreDataManager.context.perform {
            let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            do {
                let entities = try self.coreDataManager.context.fetch(fetchRequest)
                let tasks = entities.map { $0.toDomainModel }
                completion(.success(tasks))
            } catch {
                completion(.failure(.fetchTasksFailed))
            }
        }
    }
    
    func addTask(_ task: TaskModel, completion: @escaping ((Result<Bool, TaskError>) -> Void)){
        coreDataManager.context.perform {
            let entity = TaskEntity(context: self.coreDataManager.context)
            
            entity.createdDate = task.createdDate
            entity.shrtDescription = task.shortDescription
            entity.fullDescription = task.fullDescription
            entity.status = task.status.rawValue
            entity.id = task.id
            
            do {
                try self.coreDataManager.context.save()
                completion(.success(true))
            } catch {
                completion(.failure(.coreDataSaveFailed))
            }
        }
    }
    
    func removeTask(_ task: TaskModel, completion: @escaping ((Result<Bool, TaskError>) -> Void)){
        coreDataManager.context.perform {
            let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            
            do {
                let entities = try self.coreDataManager.context.fetch(fetchRequest)
                guard let entity = entities.first(where: { $0.id == task.id}) else {
                    return
                }
                
                self.coreDataManager.context.delete(entity)
                try self.coreDataManager.context.save()
                
                completion(.success(true))
            } catch {
                completion(.failure(.deleteTaskFailed))
            }
        }
    }
    
    func updateTask(_ task: TaskModel, completion: @escaping ((Result<Bool, TaskError>) -> Void)){
        coreDataManager.context.perform {
            let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            do {
                let entities = try self.coreDataManager.context.fetch(fetchRequest)
                guard let entity = entities.first(where: {$0.id == task.id}) else {
                    print("Cannot find the task with id - \(task.id)")
                    completion(.failure(.taskNotFound))
                    return
                }
                
                entity.status = task.status.rawValue
                
                try self.coreDataManager.context.save()
                completion(.success(true))
            } catch {
                print("Failed to update the task with error - \(error.localizedDescription)")
                completion(.failure(.coreDataSaveFailed))
            }
        }
    }
}
