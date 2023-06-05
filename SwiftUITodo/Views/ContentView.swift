//
//  ContentView.swift
//  SwiftUITodo
//
//  Created by Milad on 6/5/23.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    @ObservedObject var taskStore = TaskStore(realm: try! Realm())
    @State private var showingAddTaskView = false
    @State private var newTaskTitle = ""
    @State private var newTaskDescription = ""
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Todo")) {
                    ForEach(taskStore.todoTasks) { task in
                        TaskRow(task: task, taskStore: taskStore)
                    }
                    .onMove { source, destination in
                        taskStore.move(from: source, to: destination, isCompleted: false)
                    }
                }
                Section(header: Text("Completed")) {
                    ForEach(taskStore.completedTasks) { task in
                        TaskRow(task: task, taskStore: taskStore)
                    }
                    .onMove { source, destination in
                        taskStore.move(from: source, to: destination, isCompleted: true)
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Tasks")
            .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                showingAddTaskView = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddTaskView) {
                AddTaskView(taskStore: taskStore)
            }
        }
    }

    private var addButton: some View {
        Button(action: addTask) {
            Image(systemName: "plus")
        }
    }

    private func addTask() {
        taskStore.create(title: newTaskTitle, description: newTaskDescription)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
