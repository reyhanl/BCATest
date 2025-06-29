//
//  TestBCATests.swift
//  TestBCATests
//
//  Created by reyhan muhammad on 2025/6/29.
//

import Testing
import XCTest

struct TestBCATests {

    @Test func testSimpleFetch() async throws {
        let mainViewModel = MainViewModel(api: DummyPersistenceUsecase(persistence: AudioRemotePersistence()), playerManager: DummyPlayerManager())
        let audios = try await mainViewModel.fetchData()
        #expect(audios.count == 4)
    }

    @Test func testJSONReaderForDummyDataProvider() async throws {
        let bundle = Bundle(for: DummyPersistenceUsecase.self)
        let reader = JSONReader(bundle: bundle)
        let audios: [Audio] = try reader.generateDummyFromJSON(fileName: "FourAudioJSON")
        #expect(audios.count == 4)
    }

    @Test func testSearch() async throws {
        let mainViewModel = MainViewModel(api: DummyPersistenceUsecase(persistence: AudioRemotePersistence()), playerManager: DummyPlayerManager())
        await mainViewModel.search(text: "The Art of Stillness")
        #expect(mainViewModel.audios.count == 1)
    }
    
    @Test func testExecutorWithBrokenURL() async throws {
        //Should be error
        let executor = Executor()
        guard let request = DummyAPIEndpoint.getAudios(keyword: "").urlRequest else{
            throw CustomError.custom("")
        }
        do{
            let (data, response) = try await executor.execute(request: request)
        }catch{
            #expect(error.localizedDescription == "A server with the specified hostname could not be found.")
        }
        
    }
}
