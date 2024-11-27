//
//  AddTaskViewController.swift
//  ToDoApp
//
//  Created by Искандер Ситдиков on 16.11.2024.
//

import UIKit

final class AddTaskViewController: UIViewController {
    
    var onTaskSaved: (() -> Void)?
    
    // MARK: - UI
    private lazy var shortDescriptionField = {
        let textField = UITextField()
        textField.placeholder = Constants.Placeholder.shortDescription
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemGray5
        return textField
    }()
    
    private lazy var fullDescriptionField = {
        let textField = UITextField()
        textField.placeholder = Constants.Placeholder.fullDescription
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .lightGray
        return textField
    }()
    
    private lazy var datePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        return datePicker
    }()
    
    private lazy var saveButton = {
        let button = UIButton()
        button.backgroundColor = .secondarySystemBackground
        button.layer.cornerRadius = 10
        button.setTitle(Constants.Button.save, for: .normal)
        button.addTarget(nil, action: #selector(didTapSave), for: .touchUpInside)
        button.backgroundColor = .systemBlue
        return button
    }()
    
    private let viewModel: AddTaskViewModelProtocol
    
    init(viewModel: AddTaskViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        subscribeKeyboardNotification()
        shortDescriptionField.delegate = self
        fullDescriptionField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        shortDescriptionField.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    // MARK: - Private methods
    private func setupViews() {
        view.addSubview(shortDescriptionField)
        view.addSubview(datePicker)
        view.addSubview(fullDescriptionField)
        view.addSubview(saveButton)
    }
    
    private func setupConstraints() {
        
        shortDescriptionField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(40)
        }
        
        fullDescriptionField.snp.makeConstraints { make in
            make.top.equalTo(shortDescriptionField.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(80)
        }
        
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(fullDescriptionField.snp.bottom).offset(10)
            make.right.equalToSuperview().inset(10)
        }
        
        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(40)
        }
    }
    
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Keyboard notification
    private func subscribeKeyboardNotification() {
        NotificationCenter.default.addObserver(self, 
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, 
                                               object: nil)
        NotificationCenter.default.addObserver(self, 
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func constraintSaveButtonWithKeyboardHeight(_ keyboardHeight: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.saveButton.snp.updateConstraints { make in
                make.bottom
                    .equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
                    .inset(10 + keyboardHeight)
            }
        }
        view.layoutIfNeeded()
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapSave() {
        guard let shortDescription = shortDescriptionField.text,
        !shortDescription.isEmpty else { 
            showAlert(title: Constants.Error.genericTitle,
                      message: Constants.Validation.shortDescriptionEmpty)
            return }
        
        let fullDescription = fullDescriptionField.text ?? ""
        let status = TaskStatus.new
        
        let date = datePicker.date
        
        let taskId = UUID()
        
        viewModel.saveTask(id: taskId,
                           shortDescription: shortDescription,
                           fullDescription: fullDescription,
                           status: status,
                           createdDate: date)
        onTaskSaved?()
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            self.constraintSaveButtonWithKeyboardHeight(keyboardHeight)
        }
    }
    
    @objc
    func keyboardWillHide(_ notification: Notification) {
        self.constraintSaveButtonWithKeyboardHeight(0)
    }
}

// MARK: - TextFieldDelegate
extension AddTaskViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == shortDescriptionField {
            fullDescriptionField.becomeFirstResponder()
        } else if textField == fullDescriptionField {
            fullDescriptionField.resignFirstResponder()
        }
        return true
    }
}
