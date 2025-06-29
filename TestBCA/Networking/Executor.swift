//
//  Executor.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/29.
//

import Foundation

protocol APIExecutorProtocol{
    func execute(request: URLRequest) async -> (Data, URLResponse)?
}

class Executor: APIExecutorProtocol{
    func execute(request: URLRequest) async -> (Data, URLResponse)? {
        do{
            return try await URLSession.shared.data(for: request)
        }catch{
            print("error: \(error.localizedDescription)")
            return nil
        }
    }
}
