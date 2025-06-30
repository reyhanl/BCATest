//
//  ErrorSender.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/30.
//
import Foundation

class ErrorSender {
    static func sendError(error: Error) {
        NotificationCenter.default.post(name: .errorGan, object: error, userInfo: nil)
    }
}
