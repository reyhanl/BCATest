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
    
    func loadAudio() async throws -> [Audio]{
        guard let request = APIEndpoint.getAudios.urlRequest else{
            throw CustomError.custom("Failed to load Audio from API")
        }
        guard let (data, response) = await executor.execute(request: request) else{
            throw CustomError.custom("Failed to load Audio from API")
        }
        let decoder = JSONDecoder()
        return try decoder.decode([Audio].self, from: data)
    }
}

class AudioLocalPersistence: AudioPersistenceProtocol{
    
    init() {
    }
    
    func loadAudio() async throws -> [Audio]{
        //TODO: Implement local storage if necessary
        return []
    }
}
