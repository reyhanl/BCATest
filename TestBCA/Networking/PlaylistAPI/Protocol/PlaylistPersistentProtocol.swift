//
//  PlaylistPersistentProtocol.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/30.
//


protocol PlaylistAPIUseCaseProtocol{
    var persistence: PlaylistPersistenceProtocol{get set}
    
    func loadAllPlaylist() async throws -> [PlaylistModel]
    func loadPlaylist(id: String) async throws -> PlaylistModel
    func savePlaylist(playlist: PlaylistModel) async throws
}

protocol PlaylistPersistenceProtocol{
    func loadAllPlaylist(entityName: String) async throws -> [PlaylistModel]
    func loadPlaylist(id: String) async throws -> PlaylistModel
    func savePlaylist(playlist: PlaylistModel) async throws
}

