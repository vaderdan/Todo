//
//  TasksStore.swift
//  Todo
//
//  Created by Danny Lazarov on 9/15/18.
//  Copyright © 2018 Danny Lazarov. All rights reserved.
//

import Foundation

struct TaskDiff {
    var insert: [IndexPath]
    var delete: [IndexPath]
}

class TaskStore {
    var tasks = [[Task](), [Task]()]
    
    func insert(_ task: Task) -> IndexPath {
        let section = (task.isDone ?? false) ? 1 : 0
        let row = 0
        
        tasks[section].insert(task, at: row)
        
        return IndexPath(row: row, section: section)
    }
    
    @discardableResult func deleteTask(indexPath: IndexPath) -> IndexPath {
        tasks[indexPath.section].remove(at: indexPath.row)
        return indexPath
    }
    
    func moveTask(indexPath: IndexPath) -> TaskDiff {
        let isDone = indexPath.section == 1
        
        
        let oldTask = tasks[indexPath.section][indexPath.row]
        oldTask.isDone = !isDone
        
        let deleteIndex = deleteTask(indexPath: indexPath)
        let insertIndex = insert(oldTask)
        
        return TaskDiff(insert: [insertIndex], delete: [deleteIndex])
    }
}
