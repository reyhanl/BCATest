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
            throw CustomError.custom("Failed to load Audio from API")
        }
        guard let (data, response) = await executor.execute(request: request) else{
            throw CustomError.custom("Failed to load Audio from API")
        }
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
