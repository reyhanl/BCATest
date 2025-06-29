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
    
    func loadAudio() async throws -> [Audio] {
        try await persistence.loadAudio()
    }
}
