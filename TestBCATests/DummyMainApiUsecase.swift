//
//  DummyMainApiUsecase.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/29.
//

import Foundation

class DummyPersistenceUsecase: AudioAPIUseCaseProtocol{
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
    
    func generateDummyData() -> [Audio] {
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

struct JSONReader{
    let bundle: Bundle
    
    init(bundle: Bundle) {
        self.bundle = bundle
    }
    
    func generateDummyFromJSON<T: Codable>(fileName: String) throws -> T{
        let str = try JSONReader(bundle: bundle).readJSON(fileName: fileName)
        guard let data = str.data(using: .utf8) else{
            throw CustomError.custom("Failed to turn it into Data")
        }
        let json = try JSONDecoder().decode(T.self, from: data)
        return json
    }
    
    func readJSON(fileName: String) throws -> String{
        if let path = Bundle(for: DummyPersistenceUsecase.self).path(forResource: fileName, ofType: "json"){
            do{
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url)
                // Convert the data back into a string
                if let text = String(data: data, encoding: .utf8) {
                    return text
                }else{
                    throw CustomError.custom("Failed to read file")
                }
            }
        }
        throw CustomError.fileNotFound
    }
    
}
