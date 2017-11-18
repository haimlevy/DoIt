//
//  Todo.swift
//  DoIt
//
//  Created by Haim Levy on 17/11/2017.
//  Copyright © 2017 Haim Levy. All rights reserved.
//

import UIKit

class Todo : Decodable {
    var id : Int;
    var userId: Int;
    var title: String;
    var completed: Bool;
    var notes: String?;
    var dueDate: Date?;
    var hasDueDate: Bool?;
    
    init(id: Int,
         userId: Int,
         title: String,
         completed: Bool,
         notes: String?,
         dueDate: Date?,
         hasDueDate: Bool?) {
        self.id = id;
        self.userId = userId;
        self.title = title;
        self.completed = completed;
        self.notes = notes;
        self.dueDate = dueDate;
        self.hasDueDate = hasDueDate;
    }
}
