//
//  Task.swift
//  MockTrello
//
//  Created by 최강훈 on 2021/05/25.
//

import Foundation

enum Priority: Int {
    case high
    case medium
    case low
}

struct Task {
    let title: String // 작업 이름
    let priority: Priority
}
