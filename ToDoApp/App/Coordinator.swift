//
//  Coordinator.swift
//  ToDoApp
//
//  Created by Искандер Ситдиков on 17.11.2024.
//

import UIKit

protocol CoordinatorProtocol {

    init(navigationController: UINavigationController)

    func start()
}

final class AppCoordinator: CoordinatorProtocol {
    
    private let taskRepository: TaskRepositoryProtocol = TaskRepositoryImp(coreDataManager: CoreDataManager())

    private var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = TaskModule.build(taskRepository: taskRepository) { taskAction in
            switch taskAction {
            case .add:
                self.showAddTask()
            case .select(let task):
                self.showDetailTask(task)
            case .showError:
                self.showErrorAlert()
            }
        }
        navigationController.pushViewController(vc, animated: true)
    }

    // MARK: - Private

    private func showAddTask() {
        var viewModel: AddTaskViewModelProtocol = AddTaskViewModelImp(taskService: taskRepository)
        let vc = AddTaskViewController(viewModel: viewModel)
        vc.onTaskSaved = {
            self.navigationController.popViewController(animated: true)
        }
        
        viewModel.onError = { errorMessage in
            vc.showAlert(title: "error_title".localized, message: errorMessage)
        }
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func showDetailTask(_ task: TaskModel) {
        let vc = DetailTaskViewController(task: task)
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func showErrorAlert() {
        navigationController.topViewController?.showAlert(
            title: "error_title".localized,
            message: "error_unknown_title".localized
        )
    }
}
