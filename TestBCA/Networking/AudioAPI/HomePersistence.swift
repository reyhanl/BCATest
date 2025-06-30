//
//  AudioAPI.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/29.
//

import Foundation

class AudioRemotePersistence: AudioPersistenceProtocol{
    var executor: any APIExecutorProtocol
    
    init(executor: any APIExecutorProtocol = Executor()) {
        self.executor = executor
    }
    
    func loadAudio(keyword: String?) async throws -> [Audio]{
        guard let request = APIEndpoint.getAudios(keyword: keyword ?? "").urlRequest else{
            ErrorSender.sendError(error: CustomError.custom("Failed to load Audio from API"))
            throw CustomError.custom("Failed to load Audio from API")
        }
        let (data, response) = try await executor.execute(request: request)
        let decoder = JSONDecoder()
#if DEBUG
        let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        print("json: \(jsonDictionary)")
#endif
        let res = try decoder.decode(AudioResponse.self, from: data)
        return res.results
    }
}

class AudioLocalPersistence: AudioPersistenceProtocol{
    
    init() {
    }
    
    func loadAudio(keyword: String?) async throws -> [Audio] {
        //TODO: Implement local storage if necessary
        return []
    }
}
