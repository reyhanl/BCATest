//
//  PlaylistAPIUseCase.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/30.
//

class PlaylistPersistenceUsecase: PlaylistAPIUseCaseProtocol{
    
    var persistence: PlaylistPersistenceProtocol
    
    init(persistence: PlaylistPersistenceProtocol) {
        self.persistence = persistence
    }
    
    func loadAllPlaylist() async throws -> [PlaylistModel]{
        try await persistence.loadAllPlaylist(entityName: "Playlist")
    }
    
    func loadPlaylist(id: String) async throws -> PlaylistModel {
        try await persistence.loadPlaylist(id: id)
    }
    
    func savePlaylist(playlist: PlaylistModel) async throws {
        try await persistence.savePlaylist(playlist: playlist)
    }
    
    func updatePlaylist(playlist: PlaylistModel) async throws {
        try await persistence.updatePlaylist(playlist: playlist)
    }
    
    func deletePlaylist(id: String) async throws {
        try await persistence.deletePlaylist(id: id)
    }
    
    func deleteAllPlaylist() async throws {
        try await persistence.deleteAllPlaylist()
    }
}
