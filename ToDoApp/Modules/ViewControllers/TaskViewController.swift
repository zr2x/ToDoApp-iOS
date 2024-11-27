//
//  TaskViewController.swift
//  ToDoApp
//
//  Created by Искандер Ситдиков on 16.11.2024.
//

import UIKit
import SnapKit

final class TaskViewController: UIViewController {
    
    //MARK: - UI
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(nil, action: #selector(refreshData), for: .valueChanged)
        return refresh
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        return tableView
    }()
    
    private var viewModel: TaskViewModelProtocol

    init(viewModel: TaskViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(didTapAddTask))
        setupViews()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchTasks()
    }

    // MARK: - Private methods

    private func bindViewModel() {
        refreshControl.beginRefreshing()
        viewModel.onTaskUpdated = { [weak self] in
            self?.tableView.reloadData()
            self?.refreshControl.endRefreshing()
        }
        
        viewModel.onError = { [weak self] errorMessage in
            guard let self else { return }
            self.showAlert(title: Constants.Error.genericTitle, message: errorMessage)
        }
    }

    private func setupViews() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        tableView.register(ToDoTableViewCell.self, forCellReuseIdentifier: ToDoTableViewCell.identifier)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
    }
    
    private func showStatusAlert(for task: TaskModel) {
        var updatedTask = task
        let alertController = UIAlertController(title: Constants.Task.changeStatus, message: nil, preferredStyle: .actionSheet)
        
        switch task.status {
        case .new:
            alertController.addAction(UIAlertAction(title: Constants.Task.takeInProgress, style: .default, handler: { [weak self] _ in
                updatedTask.status = .inProgress
                self?.viewModel.updateTask(updatedTask)
            }))
        case .inProgress:
            alertController.addAction(UIAlertAction(title: Constants.Task.finish, style: .default, handler: { [weak self] _ in
                updatedTask.status = .done
                self?.viewModel.updateTask(updatedTask)
            }))
        case .done:
            alertController.addAction(UIAlertAction(title: Constants.Task.alreadyDone, style: .default))
            
        }
        alertController.addAction(UIAlertAction(title: Constants.Button.cancel, style: .cancel))
        present(alertController, animated: true)
    }

    //MARK: - Actions

    @objc
    private func didTapAddTask() {
        viewModel.actionHandler(.add)
    }
    
    @objc
    private func refreshData() {
        viewModel.fetchTasks()
    }
}

//MARK: - DataSource, Delegate
extension TaskViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ToDoTableViewCell.identifier, for: indexPath) as? ToDoTableViewCell else {
            return UITableViewCell()
        }
        let task = viewModel.tasks[indexPath.row]

        cell.actionHandler = { [weak self] action in
            guard let self else { return }
            switch action {
            case .statusUpdated:
                self.showStatusAlert(for: task)
            case .taskDeleted:
                self.viewModel.deleteTask(task)
            }
        }
        cell.configure(with: task, canDelete: task.canDelete)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let task = viewModel.tasks[indexPath.row]
        viewModel.actionHandler(.select(task: task))
    }
}
