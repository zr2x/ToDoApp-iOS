//
//  CoreDataManager.swift
//  ToDoApp
//
//  Created by Искандер Ситдиков on 16.11.2024.
//

import Foundation
import CoreData

protocol DataManagerProtocol {
    func createTask(id: UUID,
                    shortDescription: String,
                    fullDescription: String,
                    status: TaskStatus,
                    createdDate: Date) -> TaskEntity?
    
    func fetch<T: NSManagedObject>(_ type: T) throws -> [T]
    func update(_ object: NSManagedObject, updates: (NSManagedObject) -> Void)
    func deleteTask(with id: UUID) throws
}

final class CoreDataManager: NSObject, DataManagerProtocol {
    
    private let persistentContainer: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    override init() {
        persistentContainer = NSPersistentContainer(name: "ToDoApp")
        self.persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error {
                print("Failed to load Core Data stack: \(error.localizedDescription)")
            }
        }
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error.localizedDescription)")
            }
        }
    }

    func createTask(id: UUID, 
                    shortDescription: String,
                    fullDescription: String,
                    status: TaskStatus = .new,
                    createdDate: Date) -> TaskEntity? {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "TaskEntity", in: context) else { return nil }
        
        let task = TaskEntity(entity: entityDescription, insertInto: context)
        
        task.id = id
        task.shrtDescription = shortDescription
        task.fullDescription = fullDescription
        task.createdDate = createdDate
        
        do {
            saveContext()
        }
        return task
    }
    
    func fetch<T: NSManagedObject>(_ type: T) throws -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self))
        do {
            return try context.fetch(fetchRequest)
        } catch {
            throw TaskError.fetchTasksFailed
        }
    }
    
    func update(_ object: NSManagedObject, updates: (NSManagedObject) -> Void) {
        updates(object)
        saveContext()
    }
    
    func deleteAllTasks() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
        
        do {
            let tasks = try? context.fetch(fetchRequest) as? [TaskEntity]
            tasks?.forEach({ context.delete($0) })
        }
        saveContext()
    }
    
    func deleteTask(with id: UUID) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
        
        do {
            guard let tasks = try? context.fetch(fetchRequest) as? [TaskEntity],
                  let task = tasks.first(where: { $0.id == id }) else {
                throw TaskError.taskNotFound
            }
            context.delete(task)
            saveContext()
        } catch {
            throw TaskError.deleteTaskFailed
        }
    }
}
