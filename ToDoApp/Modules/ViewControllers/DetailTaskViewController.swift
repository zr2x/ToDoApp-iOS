//
//  DetailTaskViewController.swift
//  ToDoApp
//
//  Created by Искандер Ситдиков on 17.11.2024.
//

import UIKit

final class DetailTaskViewController: UIViewController {
    
    // MARK: - UI
    private lazy var shortDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var fullDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .systemBlue
        return label
    }()
    
    private lazy var createdLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .tertiaryLabel
        return label
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    private let task: TaskModel
    
    init(task: TaskModel) {
        self.task = task
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configure(with: task)
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Private Methods
    
    private func configure(with task: TaskModel) {
        shortDescriptionLabel.text = task.shortDescription
        fullDescriptionLabel.text = task.fullDescription?.isEmpty ?? true ? Constants.Validation.fullDescriptionEmpty : task.fullDescription
        statusLabel.text = Constants.Task.status + task.status.localized
        createdLabel.text = Constants.Task.created + task.formattedDate
    }
    
    private func setupViews() {
        view.addSubview(containerView)
        containerView.addSubview(shortDescriptionLabel)
        containerView.addSubview(statusLabel)
        containerView.addSubview(createdLabel)
        containerView.addSubview(fullDescriptionLabel)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(250)
        }
        
        shortDescriptionLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
            make.height.lessThanOrEqualTo(40)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(shortDescriptionLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
        }
        
        createdLabel.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
        }
        
        fullDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(createdLabel.snp.bottom).offset(12)
            make.left.right.bottom.equalToSuperview().inset(16)
            make.height.lessThanOrEqualTo(80)

        }
    }
}
