//
//  TasksController.swift
//  Todo
//
//  Created by Danny Lazarov on 9/15/18.
//  Copyright © 2018 Danny Lazarov. All rights reserved.
//

import UIKit

class TasksController: UITableViewController {
    
    var taskStore: TaskStore! {
        didSet {
            taskStore.tasks = TasksUtility.fetch() ?? [[Task](), [Task]()]
            
            tableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad();
        
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func addTask() {
        present(addTaskController(), animated: true, completion: nil)
    }
    
    func addTaskController() -> UIAlertController {
        let alertController = UIAlertController(title: "Add Task", message: nil, preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default) {_ in
            
            guard let name = alertController.textFields?.first?.text else { return }
            
            let newTask = Task(name: name)
            
            self.insert(task: newTask)
        }
        
        addAction.isEnabled = false
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addTextField { textField in
            textField.placeholder = "Enter task name..."
            textField.addTarget(self, action: #selector(self.handleTextChanged), for: .editingChanged)
        }
        
        alertController.addAction(addAction);
        alertController.addAction(cancelAction);
        
        return alertController
    }
    
    @objc private func handleTextChanged(_ sender: UITextField) {
        
        guard let alertController = presentedViewController as? UIAlertController,
              let addAction = alertController.actions.first,
              let text = sender.text
              else { return }
        
        addAction.isEnabled = !text.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    func insert(task: Task) {
        let indexPath = taskStore.insert(task)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func delete(indexPath: IndexPath) {
        taskStore.deleteTask(indexPath: indexPath)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func move(indexPath: IndexPath) {
        tableView.beginUpdates()
        
        let diff = taskStore.moveTask(indexPath: indexPath)
        
        tableView.deleteRows(at: diff.delete, with: .automatic)
        tableView.insertRows(at: diff.insert, with: .automatic)
        
        tableView.endUpdates()
    }
}

// MARK: - DataSource
extension TasksController {
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "To-do" : "Done"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return taskStore.tasks.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskStore.tasks[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = taskStore.tasks[indexPath.section][indexPath.row].name
        
        return cell
    }
    
}

// MARK: - Delegate
extension TasksController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) {(action, sourceView, completionHandler) in
            
            self.delete(indexPath: indexPath)
            
            completionHandler(true)
        }
        
        deleteAction.image = #imageLiteral(resourceName: "delete")
        deleteAction.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.4901960784, blue: 0.4823529412, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let doneAction = UIContextualAction(style: .normal, title: nil) {(action, sourceView, completionHandler) in
            
            self.move(indexPath: indexPath)
            
            completionHandler(true)
        }
        
        doneAction.image = #imageLiteral(resourceName: "done")
        doneAction.backgroundColor = #colorLiteral(red: 0.231372549, green: 0.7411764706, blue: 0.6509803922, alpha: 1)
        
        return indexPath.section == 0 ? UISwipeActionsConfiguration(actions: [doneAction]) : nil
    }
    
}
