//
//  TaskModel.swift
//  SwiftUITodo
//
//  Created by Milad on 6/5/23.
//

import RealmSwift

class TodoObject: Object,Identifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String = ""
    @Persisted var descriptionNote: String = ""
    @Persisted var isCompleted: Bool = false
    @Persisted var order: Int = 0
}
