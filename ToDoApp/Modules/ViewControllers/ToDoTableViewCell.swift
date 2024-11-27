//
//  ToDoTableViewCell.swift
//  ToDoApp
//
//  Created by Искандер Ситдиков on 16.11.2024.
//

import UIKit

private struct Appereance {
    let inset: CGFloat = 5
    let height: CGFloat = 30
    let bottomInset: CGFloat = 10
}

final class ToDoTableViewCell: UITableViewCell {

    private let appereance = Appereance()

    enum Action {
        case statusUpdated
        case taskDeleted
    }

    var actionHandler: ((Action) -> Void)?

    static let identifier = "ToDoTableViewCell"

    //MARK: - UI
    private lazy var taskNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        label.textColor = .label
        return label
    }()

    private lazy var taskCreatedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        return label
    }()

    private lazy var taskStatusButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.addTarget(self, action: #selector(didTapChangeStatus), for: .touchUpInside)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        button.tintColor = .systemRed
        button.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        button.backgroundColor = .systemGray5
        button.isHidden = true
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        setupCellAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Private methods
    private func setupViews() {
        contentView.addSubview(taskNameLabel)
        contentView.addSubview(taskCreatedLabel)
        contentView.addSubview(taskStatusButton)
        contentView.addSubview(deleteButton)
    }

    private func setupConstraints() {
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(appereance.inset)
            make.height.equalTo(100)
        }
        
        taskNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(appereance.inset)
            make.left.equalToSuperview().inset(appereance.inset)
            make.right.equalTo(taskStatusButton.snp.left).inset(-appereance.inset)
            make.height.equalTo(appereance.height)
        }
        
        taskCreatedLabel.snp.makeConstraints { make in
            make.top.equalTo(taskNameLabel.snp.bottom).offset(appereance.inset)
            make.left.equalToSuperview().inset(appereance.inset)
            make.right.equalTo(taskStatusButton.snp.left).offset(-appereance.inset)
            make.height.greaterThanOrEqualTo(20)
        }
        
        taskStatusButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(appereance.inset)
            make.right.equalToSuperview().inset(appereance.inset)
            make.height.equalTo(appereance.height)
            make.width.equalTo(100)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(appereance.bottomInset)
            make.right.equalToSuperview().inset(appereance.bottomInset)
            make.width.height.equalTo(appereance.height)
        }
    }

    private func setupCellAppearance() {
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        contentView.backgroundColor = .systemBackground
    }

    func configure(with task: TaskModel, canDelete: Bool) {
        deleteButton.isHidden = !canDelete
        taskCreatedLabel.text = Constants.Task.created + task.formattedDate
        taskNameLabel.text = task.shortDescription
        taskStatusButton.setTitle(task.status.localized, for: .normal)

        switch task.status {
        case .new:
            taskStatusButton.backgroundColor = .systemBlue
        case .inProgress:
            taskStatusButton.backgroundColor = .systemOrange
        case .done:
            taskStatusButton.backgroundColor = .systemGreen
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(false, animated: animated)
    }

    // MARK: - Actions

    @objc
    private func didTapChangeStatus() {
        actionHandler?(.statusUpdated)
    }

    @objc
    private func didTapDeleteButton() {
        actionHandler?(.taskDeleted)
    }
}
