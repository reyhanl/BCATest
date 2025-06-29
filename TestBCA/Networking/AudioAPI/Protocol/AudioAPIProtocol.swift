//
//  AudioAPIProtocol.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/29.
//
import Foundation

protocol AudioAPIUseCaseProtocol{
    var persistence: AudioPersistenceProtocol{get set}
    
    func loadAudio(keyword: String?) async throws -> [Audio]
}

protocol AudioPersistenceProtocol{    
    func loadAudio(keyword: String?) async throws -> [Audio]
}

