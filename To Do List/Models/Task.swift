//
//  Task.swift
//  To Do List
//
//  Created by Aline do Amaral on 27/03/23.
//

import Foundation

struct Task: Codable {
    var taskName: String
    let id: String
    
    init(taskName: String) {
        self.taskName = taskName
        self.id = String(NSDate().timeIntervalSince1970)
    }
}
