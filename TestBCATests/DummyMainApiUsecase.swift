//
//  DummyMainApiUsecase.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/29.
//

import Foundation

class DummyPersistenceUsecase: AudioAPIUseCaseProtocol, AudioPersistenceProtocol{
    
    var persistence: AudioPersistenceProtocol
    
    init(persistence: AudioPersistenceProtocol) {
        self.persistence = persistence
    }
    
    func loadAudio(keyword: String?) async throws -> [Audio]{
        let reader = JSONReader(bundle: Bundle(for: type(of: self)))
        let audios: [Audio] = try reader.generateDummyFromJSON(fileName: "FourAudioJSON")
        if let keyword = keyword{
            print("count: \(audios.count)")
            return audios.filter({$0.title.contains(keyword)})
        }
        return audios
    }
    
    func savePlaylist(playlist: PlaylistModel) async throws {
        
    }
}

