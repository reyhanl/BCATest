//
//  AudioAPIUseCase.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/29.
//
import Foundation

class AudioPersistenceUsecase: AudioAPIUseCaseProtocol{
    var persistence: AudioPersistenceProtocol
    
    init(persistence: AudioPersistenceProtocol) {
        self.persistence = persistence
    }
    
    func loadAudio(keyword: String?) async throws -> [Audio]{
        try await persistence.loadAudio(keyword: keyword)
    }
    
    func savePlaylist(playlist: PlaylistModel) async throws {
        try await persistence.savePlaylist(playlist: playlist)
    }
}

class MockAudioPersistenceUsecase: AudioAPIUseCaseProtocol{
    var persistence: AudioPersistenceProtocol
    
    init(persistence: AudioPersistenceProtocol) {
        self.persistence = persistence
    }
    
    func loadAudio(keyword: String?) async throws -> [Audio]{
        try await persistence.loadAudio(keyword: keyword)
    }
    
    func savePlaylist(playlist: PlaylistModel) async throws {
        try await persistence.savePlaylist(playlist: playlist)
    }
}

