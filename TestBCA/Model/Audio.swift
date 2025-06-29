//
//  Audio.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/29.
//

import Foundation

struct AudioResponse: Codable {
    let resultCount: Int
    let results: [Audio]
}

public class Audio: Codable, NSCoding, Identifiable {
    public func encode(with coder: NSCoder) {
        coder.encode(wrapperType.rawValue, forKey: CodingKeys.wrapperType.rawValue)
        switch wrapperType {
        case .audiobook:
            coder.encode(title, forKey: CodingKeys.collectionName.rawValue)
        case .song:
            coder.encode(title, forKey: CodingKeys.title.rawValue)
        }
        coder.encode(id, forKey: CodingKeys.collectionId.rawValue)
        coder.encode(artistName, forKey: CodingKeys.artistName.rawValue)
        coder.encode(artworkUrl100, forKey: CodingKeys.artworkUrl100.rawValue)
        coder.encode(previewUrl, forKey: CodingKeys.previewUrl.rawValue)
    }
    
    public required init?(coder: NSCoder) {
        // Decode wrapperType safely
        guard let wrapperString = coder.decodeObject(forKey: CodingKeys.wrapperType.rawValue) as? String,
              let wrapper = AudioType(rawValue: wrapperString)
        else {
            return nil
        }
        self.wrapperType = wrapper

        self.id = coder.decodeInteger(forKey: CodingKeys.collectionId.rawValue)
        self.artistName = coder.decodeObject(forKey: CodingKeys.artistName.rawValue) as? String ?? ""

        switch wrapper {
        case .audiobook:
            self.title = coder.decodeObject(forKey: CodingKeys.collectionName.rawValue) as? String ?? ""
        case .song:
            self.title = coder.decodeObject(forKey: CodingKeys.title.rawValue) as? String ?? ""
        }

        self.artworkUrl100 = coder.decodeObject(forKey: CodingKeys.artworkUrl100.rawValue) as? String
        self.previewUrl = coder.decodeObject(forKey: CodingKeys.previewUrl.rawValue) as? String
    }
    
    let wrapperType: AudioType
    public let id: Int // using collectionId
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
    
    required public init(from decoder: any Decoder) throws {
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
    
    public func encode(to encoder: any Encoder) throws {
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
