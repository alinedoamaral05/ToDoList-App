//
//  ToDoTableViewCell.swift
//  To Do List
//
//  Created by Aline do Amaral on 24/03/23.
//

import UIKit
protocol DeleteCellDelegate {
    func deleteTaskCell(id: String)
}

class TaskTableViewCell: UITableViewCell {
    var delegate: DeleteCellDelegate?
    private var identifier: String?
    
//MARK: - Components
    private let stackViewTaskAndTrash: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalCentering
        stack.spacing = 5
        return stack
    }()
    
    private var taskLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemBrown
        label.backgroundColor = .clear
        label.font = UIFont(name: "Arial", size: 18)
        label.numberOfLines = 0
        return label
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "trash.fill"), for: .normal)
        button.tintColor = UIColor(named: "deleteButton")
        return button
    }()

//MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupLayout()
    }
    
    //MARK: - Methods
    func addNewTask(task: Task) {
        taskLabel.text = task.taskName
        identifier = task.id
    }
    
    
    private func setTargetToButton() {
        deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
    }
    
    @objc func deleteButtonPressed(_ sender: UIButton) {
        guard let id = identifier else { return }
        delegate?.deleteTaskCell(id: id)
    }
    
    //MARK: - Setup UI
    private func setupLayout() {
        setupHierarchy()
        setupConstraints()
        setTargetToButton()
        self.backgroundColor = UIColor(white: 1, alpha: 0.85)
    }
    
    private func setupHierarchy() {
        addSubview(stackViewTaskAndTrash)
        stackViewTaskAndTrash.addArrangedSubview(taskLabel)
        stackViewTaskAndTrash.addArrangedSubview(deleteButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackViewTaskAndTrash.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            stackViewTaskAndTrash.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackViewTaskAndTrash.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            stackViewTaskAndTrash.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            deleteButton.heightAnchor.constraint(equalToConstant: 20),
            deleteButton.widthAnchor.constraint(equalToConstant: 20),
        ])
    }
}
