//
//  TaskRow.swift
//  SwiftUITodo
//
//  Created by Milad on 6/5/23.
//

import SwiftUI

struct TaskRow: View {
    var task: TodoObject
    var taskStore: TaskStore

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(task.title)
                Text(task.descriptionNote)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: task.isCompleted ? "checkmark.square" : "square")
            
        }
        .contentShape(Rectangle())  // This makes the whole row tappable
        .onTapGesture {
            withAnimation {
                taskStore.update(task: task, newTitle: task.title, newDescription: task.descriptionNote, isCompleted: !task.isCompleted)
            }
        }
    }
}
