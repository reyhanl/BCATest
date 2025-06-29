//
//  Error.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/29.
//

enum CustomError: Error{
    case custom(String)
    case failedToLoadContext
    case failedToLoadEntity
}
