//
//  TaskStore.swift
//  SwiftUITodo
//
//  Created by Milad on 6/5/23.
//

import RealmSwift

class TaskStore: ObservableObject {
    private var todoResults: Results<TodoObject>
    private var completedResults: Results<TodoObject>

    init(realm: Realm) {
        todoResults = realm.objects(TodoObject.self).where { obj in
            obj.isCompleted == false
        }
        completedResults = realm.objects(TodoObject.self).where { obj in
            obj.isCompleted == true
        }
    }

    var todoTasks: [TodoObject] {
        todoResults.sorted(byKeyPath: "order").map(TodoObject.init)
    }

    var completedTasks: [TodoObject] {
        completedResults.sorted(byKeyPath: "order").map(TodoObject.init)
    }

    func create(title: String, description: String) {
        do {
            let realm = try Realm()
            
            let task = TodoObject()
            task.title = title
            task.descriptionNote = description
            
            try realm.write {
                realm.add(task)
            }
            
            // Notify observers after the task has been added to the Realm
            self.objectWillChange.send()

        } catch let error {
            // Handle error
            print(error.localizedDescription)
        }
    }

    func update(task: TodoObject, newTitle: String, newDescription: String, isCompleted: Bool) {
       
        objectWillChange.send()
        do {
            let realm = try Realm()

            try realm.write {
                task.title = newTitle
                task.descriptionNote = newDescription
                task.isCompleted = isCompleted
                realm.add(task, update: .all)
            }
        } catch let error {
            // Handle error
            print(error.localizedDescription)
        }
    }

    func move(from source: IndexSet, to destination: Int, isCompleted: Bool) {
            objectWillChange.send()

            do {
                let realm = try Realm()

                try realm.write {
                    let sourceIndex = source.first!
                    let destinationIndex = destination > sourceIndex ? destination - 1 : destination

                    let tasks = isCompleted ? completedTasks : todoTasks
                    let movedTask = tasks[sourceIndex]

                    if destinationIndex < sourceIndex {
                        for index in destinationIndex..<sourceIndex {
                            tasks[index].order += 1
                        }
                    } else {
                        for index in (sourceIndex + 1)...destinationIndex {
                            tasks[index].order -= 1
                        }
                    }

                    movedTask.order = destinationIndex
                    realm.add(tasks, update: .all)
                    realm.add(movedTask, update:  .all)
                }
            } catch let error {
                // Handle error
                print(error.localizedDescription)
            }
        }
    
    func delete(task: TodoObject) {
       
        objectWillChange.send()
        do {
            let realm = try Realm()

            try realm.write {
                realm.delete(task)
            }
        } catch let error {
            // Handle error
            print(error.localizedDescription)
        }
    }
}
