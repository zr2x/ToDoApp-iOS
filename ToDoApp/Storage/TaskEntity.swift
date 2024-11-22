//
//  TaskEntity.swift
//  ToDoApp
//
//  Created by Искандер Ситдиков on 16.11.2024.
//

import CoreData

extension TaskEntity {

    var toDomainModel: TaskModel {
        return TaskModel(
            id: self.id ?? UUID(),
            shortDescription: self.shrtDescription ?? "",
            fullDescription: self.fullDescription,
            status: TaskStatus(rawValue: self.status ?? TaskStatus.new.rawValue) ?? .new,
            createdDate: self.createdDate ?? Date()
        )
    }
}
