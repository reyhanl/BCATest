//
//  Audio.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/29.
//

struct AudioResponse: Codable {
    let resultCount: Int
    let results: [Audio]
}

struct Audio: Codable, Identifiable {
    let wrapperType: AudioType
    let id: Int // using collectionId
    let title: String // using collectionName
    let artistName: String
    let artworkUrl100: String?
    let previewUrl: String?
    
    init(wrapperType: String, id: Int, title: String, artistName: String, artworkUrl100: String? = nil, previewUrl: String? = nil) {
        self.wrapperType = .init(rawValue: wrapperType) ?? .audiobook
        self.id = id
        self.title = title
        self.artistName = artistName
        self.artworkUrl100 = artworkUrl100
        self.previewUrl = previewUrl
    }

    enum CodingKeys: String, CodingKey {
        case title = "trackName"
        case wrapperType
        case collectionId
        case collectionName
        case artistName
        case artworkUrl100
        case previewUrl
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let wrapper = try container.decode(String.self, forKey: .wrapperType)
        self.wrapperType = AudioType(rawValue: wrapper) ?? .song
        if let id = try? container.decode(Int.self, forKey: .collectionId){
            self.id = id
        }else{
            self.id = -1
        }
        switch wrapperType {
        case .audiobook:
            self.title = try container.decode(String.self, forKey: .collectionName)
        case .song:
            self.title = try container.decode(String.self, forKey: .title)
        }
        self.artistName = try container.decode(String.self, forKey: .artistName)
        self.artworkUrl100 = try container.decodeIfPresent(String.self, forKey: .artworkUrl100)
        self.previewUrl = try container.decodeIfPresent(String.self, forKey: .previewUrl)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(wrapperType.rawValue, forKey: .wrapperType)
        switch wrapperType {
        case .audiobook:
            try container.encode(title, forKey: .collectionName)
        case .song:
            try container.encode(title, forKey: .title)
        }
        try container.encode(id, forKey: .collectionId)
        try container.encode(artistName, forKey: .artistName)
        try container.encodeIfPresent(artworkUrl100, forKey: .artworkUrl100)
        try container.encodeIfPresent(previewUrl, forKey: .previewUrl)
    }
}

enum AudioType: String{
    case audiobook = "audiobook"
    case song = "track"
}
