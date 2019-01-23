//
//  TodoTests.swift
//  TodoTests
//
//  Created by Danny on 22.01.19.
//  Copyright © 2019 Danny Lazarov. All rights reserved.
//

import Foundation
import XCTest
import SnapshotTesting
@testable import Todo


class TodoTests: XCTestCase {
    
    override func setUp() {
//        diffTool = "ksdiff"
//        record = true
    }
    
    override func tearDown() {
    }
    
    func testAny() {
        struct User { let id: Int, name: String, bio: String }
        let user = User(id: 2, name: "Blobby", bio: "Blobbed around the world.")
        assertSnapshot(matching: user, as: .dump)
    }
    
    func testController() {
        let taskStore = TaskStore()
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "TasksController") as! TasksController
        vc.taskStore = taskStore
        
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        
        vc.insert(task: Task(name: "test2"))
        vc.insert(task: Task(name: "test3"))
        vc.move(indexPath: IndexPath(row: 0, section: 0))
        vc.delete(indexPath: IndexPath(row: 0, section: 0))
        
        assertSnapshot(matching: vc, as: .recursiveDescription)
    }
    
    func testControllerAdd() {
        let taskStore = TaskStore()
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "TasksController") as! TasksController
        vc.taskStore = taskStore
        
        let addTaskVc = vc.addTaskController()
        addTaskVc.view.translatesAutoresizingMaskIntoConstraints = false
        
        assertSnapshot(matching: vc.addTaskController(), as: .recursiveDescription)
    }
    
    func testControllerStats() {
        let taskStore = TaskStore()
        taskStore.insert(Task(name: "task1"))
        taskStore.insert(Task(name: "task2"))
        taskStore.insert(Task(name: "task3"))
        taskStore.moveTask(indexPath: IndexPath(row: 0, section: 0))
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "StatsController") as! StatsController
        vc.taskStore = taskStore
        
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        
        assertSnapshot(matching: vc, as: .image)
    }
}
