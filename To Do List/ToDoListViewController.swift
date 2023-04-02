//
//  ViewController.swift
//  To Do List
//
//  Created by Aline do Amaral on 24/03/23.
//

import UIKit

class ToDoListViewController: UIViewController {
    //MARK: - Variables
    let viewModel: ViewModel

    //MARK: - Components
    private let backgroundImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "background")
        return image
    }()
    
    private let toDoListAppTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Arial", size: 25)
        label.text = "TO DO LIST"
        label.textColor = .brown
        return label
    }()
    
    private let viewForTextField: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 1, alpha: 0.85)
        view.layer.borderColor = UIColor.systemBrown.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private let searchStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 1
        return stackView
    }()
    
    private let addNewItemTextField: UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.backgroundColor = .clear
        textfield.tintColor = .black
        textfield.placeholder = "Add a note"
        return textfield
    }()
    
    private let addTaskButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemGray
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.systemBrown.cgColor
        button.layer.borderWidth = 1
        button.isEnabled = false
        return button
    }()
    
    private let listTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "TaskTableViewCell")
        tableView.backgroundColor = .clear
        tableView.tintColor = .black
        tableView.allowsSelection = false
        return tableView
    }()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupApp()
    }
    
    //MARK: - Methods
    func setupApp() {
        setupUI()
        delegateSetup()
        addTargetToButton()
    }
    
    @objc private func didTapAddTaskButton() {
        viewModel.setTaskName(textField: addNewItemTextField, tableView: listTableView )
    }
    
    private func addTargetToButton() {
        addTaskButton.addTarget(self, action: #selector(didTapAddTaskButton), for: .touchUpInside)
    }
    
    private func textfieldVerification() {
        viewModel.verifyIfTextfieldIsEmpty(textfield: addNewItemTextField, button: addTaskButton)
    }
    
    //MARK: - Init
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup Delegates
    private func delegateSetup() {
        listTableView.delegate = self
        listTableView.dataSource = self
        addNewItemTextField.delegate = self
        viewModel.viewDidLoad()
        viewModel.delegate = self
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupHierarchy() {
        view.addSubview(backgroundImage)
        view.addSubview(toDoListAppTitle)
        view.addSubview(viewForTextField)
        viewForTextField.addSubview(searchStackView)
        searchStackView.addArrangedSubview(addNewItemTextField)
        searchStackView.addArrangedSubview(addTaskButton)
        view.addSubview(listTableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            toDoListAppTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            toDoListAppTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            viewForTextField.topAnchor.constraint(equalTo: toDoListAppTitle.bottomAnchor, constant: 15),
            viewForTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            viewForTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            viewForTextField.heightAnchor.constraint(equalToConstant: 44),
            
            searchStackView.topAnchor.constraint(equalTo: viewForTextField.topAnchor),
            searchStackView.leadingAnchor.constraint(equalTo: viewForTextField.leadingAnchor, constant: 10),
            searchStackView.trailingAnchor.constraint(equalTo: viewForTextField.trailingAnchor),
            searchStackView.bottomAnchor.constraint(equalTo: viewForTextField.bottomAnchor),
            
            addTaskButton.heightAnchor.constraint(equalToConstant: 44),
            addTaskButton.widthAnchor.constraint(equalToConstant: 44),
            
            listTableView.topAnchor.constraint(equalTo: viewForTextField.bottomAnchor, constant: 20),
            listTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            listTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            listTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])
    }
}

//MARK: - TableViewDelegate/DataSource
extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.taskLisSize()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
        cell.delegate = self
        cell.addNewTask(task: viewModel.taskList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.estimatedRowHeight
    }
}

//MARK: - TextFieldDelegate
extension ToDoListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textfieldVerification()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        textfieldVerification()
    }
}

//MARK: - DeleteCellDelegate
extension ToDoListViewController: ViewModelDelegate {}

//MARK: - DeleteCellDelegate
extension ToDoListViewController: DeleteCellDelegate {
    func deleteTaskCell(id: String) {
        viewModel.deleteCell(tableView: listTableView, id: id)
    }
}
