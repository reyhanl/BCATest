//
//  Executor.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/29.
//

import Foundation
protocol APIExecutorProtocol{
    func execute(request: URLRequest) async throws -> (Data, URLResponse)
}

class Executor: APIExecutorProtocol{
    func execute(request: URLRequest) async throws -> (Data, URLResponse) {
        do{
#if DEBUG
            print("request: \(request.url?.absoluteString)")
#endif
            return try await URLSession.shared.data(for: request)
        }catch{
            print("error: \(error.localizedDescription)")
            throw error
        }
    }
}
