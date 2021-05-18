//
//  ViewController.swift
//  HelloRxSwift
//
//  Created by 최강훈 on 2021/05/17.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        _ = Observable.from([1, 2, 3, 4, 5])
    }


}

