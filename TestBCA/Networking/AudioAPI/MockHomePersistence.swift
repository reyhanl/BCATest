//
//  MockHomePersistence.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/30.
//

import Foundation

class MockHomePersistence: AudioPersistenceProtocol{
    
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

