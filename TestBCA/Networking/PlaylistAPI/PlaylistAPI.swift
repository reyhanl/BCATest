//
//  PlaylistAPI.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/30.
//
import CoreData

class PlaylistRemotePersistence: PlaylistPersistenceProtocol{
    
    var executor: any APIExecutorProtocol
    
    init(executor: any APIExecutorProtocol = Executor()) {
        self.executor = executor
    }
    func loadAllPlaylist(entityName: String) async throws -> [PlaylistModel]{
        return []
    }
    
    func loadPlaylist(id: String) async throws -> PlaylistModel {
        throw CustomError.custom("")
    }
    
    func savePlaylist(playlist: PlaylistModel) async throws{
    }
    
    func deletePlaylist(id: String) async throws {
        
    }
    
    func deleteAllPlaylist() async throws {
        
    }
    
    func updatePlaylist(playlist: PlaylistModel) async throws {
    }
}

class PlaylistLocalPersistence: PlaylistPersistenceProtocol{
    
    var helper: CoreDataHelperProtocol
    var entityName: String
    
    init(helper: CoreDataHelperProtocol, entityName: String) {
        self.helper = helper
        self.entityName = entityName
    }
    
    func updatePlaylist(playlist: PlaylistModel) async throws {
        try helper.replace(entity: entityName, predicate: NSPredicate(format: "id == %@", playlist.id), object: playlist)
    }
    
    func loadAllPlaylist(entityName: String) async throws -> [PlaylistModel]{
        let playlists: [PlaylistModel] = try helper.getGeneric(entityName: entityName, predicate: nil)
        return playlists
    }
    
    func loadPlaylist(id: String) async throws -> PlaylistModel {
        //TODO: Not yet implemented
        throw CustomError.custom("")
    }
    
    func savePlaylist(playlist: PlaylistModel) async throws{
        try helper.save(entity: entityName, object: playlist)
    }
    
    func deletePlaylist(id: String) async throws {
        try helper.delete(entity: entityName, predicate: NSPredicate(format: "id == %@", id), deleteAll: false)
    }
    
    func deleteAllPlaylist() async throws {
        try helper.delete(entity: entityName, predicate: nil, deleteAll: true)
    }
}
