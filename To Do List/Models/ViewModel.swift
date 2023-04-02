//
//  ViewModel.swift
//  To Do List
//
//  Created by Aline do Amaral on 25/03/23.
//

import UIKit

protocol ViewModelDelegate {
}

class ViewModel {
    
    var delegate: ViewModelDelegate?
    var taskList: [Task] = [] {
        didSet {
            persistTaskList()
        }
    }
    let estimatedRowHeight: CGFloat = 50

    init() {
        taskList = retrieveToDoList()
    }
    
    func viewDidLoad() {
        
    }
    
    func setTaskName(textField: UITextField, tableView: UITableView) {
        guard let newTask = textField.text else {return}
        taskList.append(Task(taskName: newTask))
        textField.text = nil
        tableView.reloadData()
    }
    func deleteCell(tableView: UITableView, id: String) {
        guard let taskItem = taskList.firstIndex(where: { $0.id == id }) else { return }
        taskList.remove(at: taskItem)
        tableView.reloadData()
    }
    func persistTaskList() {
        let encoded = try? JSONEncoder().encode(taskList)
        let userDefaults = UserDefaults()
        userDefaults.set(encoded, forKey: "taskList")
    }
    
    func retrieveToDoList() -> [Task] {
        let userDefaults = UserDefaults()
        guard let taskData = userDefaults.data(forKey: "taskList") else { return [] }
        return try! JSONDecoder().decode([Task].self, from: taskData)
    }
    
    func taskLisSize() -> Int {
        taskList.count
    }
    
    func verifyIfTextfieldIsEmpty(textfield: UITextField, button: UIButton) {
        if textfield.text?.count == 0 {
            button.tintColor = .systemGray
            button.isEnabled = false
        } else {
            button.tintColor = .systemGreen
            button.isEnabled = true
        }
    }
}
