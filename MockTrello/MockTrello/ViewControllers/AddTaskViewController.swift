//
//  AddTaskViewController.swift
//  MockTrello
//
//  Created by 최강훈 on 2021/05/25.
//

import UIKit
import RxSwift

class AddTaskViewController: UIViewController {

    private let taskSubject = PublishSubject<Task>()
    
    var taskSubjectObservable: Observable<Task> {
        return taskSubject.asObservable()
    }
    
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet weak var taskTitleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
 
    @IBAction func touchUpSaveButton(_ sender: Any) {
        
        guard let priority = Priority(rawValue:
                self.prioritySegmentedControl.selectedSegmentIndex),
                let title = self.taskTitleTextField.text
        else { return }
        
        let task = Task(title: title, priority: priority)
        
        taskSubject.onNext(task)
        
        self.dismiss(animated: true, completion: nil)
        
    }

}
