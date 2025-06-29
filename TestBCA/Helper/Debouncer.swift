//
//  Debouncer.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/29.
//
import Foundation

class Debouncer {
    private var workItem: DispatchWorkItem?
    private let queue: DispatchQueue
    private let interval: TimeInterval
    private let syncQueue = DispatchQueue(label: "debouncer.sync.queue")

    init(interval: TimeInterval, queue: DispatchQueue = DispatchQueue.main) {
        self.interval = interval
        self.queue = queue
    }

    func debounce(action: @escaping () -> Void) {
        syncQueue.sync {
            // Cancel the previous task if there is one
            workItem?.cancel()

            // Create a new task
            let workItem = DispatchWorkItem { [weak self] in
                // Necessary to prevent memory leaks
                self?.syncQueue.sync {
                    action()
                }
            }
            
            self.workItem = workItem

            // Run the task after the specified interval
            queue.asyncAfter(deadline: .now() + interval, execute: workItem)
        }
    }
}

