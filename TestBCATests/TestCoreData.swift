//
//  TestC.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/30.
//
import Testing
import CoreData

struct TestCoreDataTests {
    
    var coreDataName: String = "Data"
    var entityName: String = "Playlist"
    
    @Test func testSaveObject() async throws {
        let container = NSPersistentContainer(name: coreDataName)
        container.persistentStoreDescriptions[0].url = URL(fileURLWithPath: "/dev/null")
        
        let helper = CoreDataHelper.init(stack: .init(persistent: container))
        let playlist = try helper.get(entityName: entityName)
        #expect(playlist.count == 0)
        let dummyPlaylist = PlaylistGenerator.generatePlaylists()
        for playlist in dummyPlaylist {
            try helper.save(entity: entityName, object: playlist)
        }
        let playlists = try helper.get(entityName: entityName)
        #expect(dummyPlaylist.count == playlists.count)
    }
    
    @Test func testDeleteData() async throws {
        let container = NSPersistentContainer(name: coreDataName)
        container.persistentStoreDescriptions[0].url = URL(fileURLWithPath: "/dev/null")
        
        let helper = CoreDataHelper.init(stack: .init(persistent: container))
        let playlist = try helper.get(entityName: entityName)
        #expect(playlist.count == 0)
        let dummyPlaylist = PlaylistGenerator.generatePlaylists()
        for playlist in dummyPlaylist {
            try helper.save(entity: entityName, object: playlist)
        }
        let playlists = try helper.get(entityName: entityName)
        #expect(dummyPlaylist.count == playlists.count)
        
        if let playlist = dummyPlaylist.first{
            try helper.delete(entity: entityName, predicate: NSPredicate(format: "id == %@", playlist.id))
            let tempPlaylists = try helper.get(entityName: entityName)
            #expect(tempPlaylists.count == dummyPlaylist.count - 1)
        }else{
            throw CustomError.custom("Failed to delete because there is no data")
        }
    }
    
    func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
        // Load the managed object model from the main bundle
        guard let model = NSManagedObjectModel.mergedModel(from: [Bundle.main]) else {
            fatalError("Failed to load managed object model")
        }

        // Create a persistent store coordinator with the model
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)

        do {
            try coordinator.addPersistentStore(
                ofType: NSInMemoryStoreType,
                configurationName: nil,
                at: nil,
                options: nil
            )
        } catch {
            fatalError("Failed to add in-memory store: \(error)")
        }

        // Create and return a managed object context
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator

        return context
    }
}

struct PlaylistGenerator{
    static func generatePlaylists() -> [PlaylistModel]{
        let audios = Audios(audios: generateDummyData())
        let playlistModel = PlaylistModel(id: "2", title: "Cool", audios: audios)
        let playlistModel2 = PlaylistModel(id: "1", title: "Buat bobo", audios: audios)
        let playlistModel3 = PlaylistModel(id: "3", title: "Keren bangett", audios: audios)
        return [playlistModel, playlistModel2, playlistModel3]
    }
    
    static func generateDummyData() -> [Audio] {
            return [
                Audio(
                    wrapperType: "track",
                    id: 1001,
                    title: "Evening Melodies",
                    artistName: "Calm Sounds",
                    artworkUrl100: "https://example.com/images/piano.jpg",
                    previewUrl: "https://example.com/audio/peaceful_piano.mp3"
                ),
                Audio(
                    wrapperType: "audiobook",
                    id: 2001,
                    title: "The Art of Stillness",
                    artistName: "Pico Iyer",
                    artworkUrl100: "https://example.com/images/stillness.jpg",
                    previewUrl: "https://example.com/audio/art_of_stillness_sample.mp3"
                ),
                Audio(
                    wrapperType: "track",
                    id: 1002,
                    title: "Lo-fi Beats",
                    artistName: "Lo-Fi Producer",
                    artworkUrl100: nil,
                    previewUrl: nil
                )
            ]
        }

}
