//
//  TaskListViewController.swift
//  MockTrello
//
//  Created by 최강훈 on 2021/05/25.
//

import UIKit
import RxSwift
import RxCocoa

class TaskListViewController: UIViewController {

    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    // private var tasks = Variable<[Task]>([])
    private var tasks = BehaviorRelay<[Task]>(value: [])
    private var filteredTasks = [Task]()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        

        self.tableView.dataSource = self
        self.tableView.delegate = self
        
    }
    


    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let navigationController = segue.destination as? UINavigationController,
              let addTaskViewController = navigationController.viewControllers.first as? AddTaskViewController
        else { fatalError("Controller not found") }
        
        addTaskViewController.taskSubjectObservable
            .subscribe(onNext: { [unowned self] task in
                print(task)
                
                let priority
                    = Priority(rawValue:
                        self.prioritySegmentedControl.selectedSegmentIndex - 1)
                
                var existingTasks = self.tasks.value
                existingTasks.append(task)
                self.tasks.accept(existingTasks)
                self.filterTasks(by: priority)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }).disposed(by: disposeBag)
        
        
    }
    
    private func filterTasks(by priority: Priority?) {
        if priority == nil {
            self.filteredTasks = self.tasks.value
        } else {
            self.tasks.map { tasks in
                return tasks.filter { $0.priority == priority! }
            }.subscribe(onNext: { [weak self] tasks in
                self?.filteredTasks = tasks
            }).disposed(by: disposeBag)
            
        }
        
    }

    
    @IBAction func priorityValueChanged(segmentedControl: UISegmentedControl) {
        let priority = Priority(rawValue: segmentedControl.selectedSegmentIndex - 1)
        filterTasks(by: priority)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =
                self.tableView.dequeueReusableCell(withIdentifier: "toDoCell") as? TaskTableViewCell
        else {return UITableViewCell()}
        
        let task = self.filteredTasks[indexPath.row]
        
        cell.titleLabel?.text = task.title
        switch task.priority {
        case Priority.high:
            cell.priorityLabel?.textColor = .red
            cell.priorityLabel?.text = "High"
        case Priority.medium:
            cell.priorityLabel?.textColor = .orange
            cell.priorityLabel?.text = "Medium"
        case Priority.low:
            cell.priorityLabel?.textColor = .gray
            cell.priorityLabel?.text = "Low"
        }
        
        
        return cell
    }
}

extension TaskListViewController: UITableViewDelegate {
    
}
