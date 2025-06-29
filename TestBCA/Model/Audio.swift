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

struct Audio: Codable{
    let wrapperType: AudioType
    let artistId: Int
    let collectionId: Int
    let amgArtistId: Int?
    let artistName: String
    let collectionName: String
    let collectionCensoredName: String
    let artistViewUrl: String
    let collectionViewUrl: String
    let artworkUrl60: String
    let artworkUrl100: String
    let collectionPrice: Double
    let collectionExplicitness: String
    let trackCount: Int
    let copyright: String?
    let country: String
    let currency: String
    let releaseDate: String
    let primaryGenreName: String
    let previewUrl: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case wrapperType
        case artistId
        case collectionId
        case amgArtistId
        case artistName
        case collectionName
        case collectionCensoredName
        case artistViewUrl
        case collectionViewUrl
        case artworkUrl60
        case artworkUrl100
        case collectionPrice
        case collectionExplicitness
        case trackCount
        case copyright
        case country
        case currency
        case releaseDate
        case primaryGenreName
        case previewUrl
        case description
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let wrapperType = try container.decode(String.self, forKey: .wrapperType)
        self.wrapperType = AudioType(rawValue: wrapperType) ?? .song
        self.artistId = try container.decode(Int.self, forKey: .artistId)
        self.collectionId = try container.decode(Int.self, forKey: .collectionId)
        self.amgArtistId = try container.decodeIfPresent(Int.self, forKey: .amgArtistId)
        self.artistName = try container.decode(String.self, forKey: .artistName)
        self.collectionName = try container.decode(String.self, forKey: .collectionName)
        self.collectionCensoredName = try container.decode(String.self, forKey: .collectionCensoredName)
        self.artistViewUrl = try container.decode(String.self, forKey: .artistViewUrl)
        self.collectionViewUrl = try container.decode(String.self, forKey: .collectionViewUrl)
        self.artworkUrl60 = try container.decode(String.self, forKey: .artworkUrl60)
        self.artworkUrl100 = try container.decode(String.self, forKey: .artworkUrl100)
        self.collectionPrice = try container.decode(Double.self, forKey: .collectionPrice)
        self.collectionExplicitness = try container.decode(String.self, forKey: .collectionExplicitness)
        self.trackCount = try container.decode(Int.self, forKey: .trackCount)
        self.copyright = try container.decodeIfPresent(String.self, forKey: .copyright)
        self.country = try container.decode(String.self, forKey: .country)
        self.currency = try container.decode(String.self, forKey: .currency)
        self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
        self.primaryGenreName = try container.decode(String.self, forKey: .primaryGenreName)
        self.previewUrl = try container.decode(String.self, forKey: .previewUrl)
        self.description = try container.decode(String.self, forKey: .description)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(wrapperType.rawValue, forKey: .wrapperType)
        try container.encode(artistId, forKey: .artistId)
        try container.encode(collectionId, forKey: .collectionId)
        try container.encodeIfPresent(amgArtistId, forKey: .amgArtistId)
        try container.encode(artistName, forKey: .artistName)
        try container.encode(collectionName, forKey: .collectionName)
        try container.encode(collectionCensoredName, forKey: .collectionCensoredName)
        try container.encode(artistViewUrl, forKey: .artistViewUrl)
        try container.encode(collectionViewUrl, forKey: .collectionViewUrl)
        try container.encode(artworkUrl60, forKey: .artworkUrl60)
        try container.encode(artworkUrl100, forKey: .artworkUrl100)
        try container.encode(collectionPrice, forKey: .collectionPrice)
        try container.encode(collectionExplicitness, forKey: .collectionExplicitness)
        try container.encode(trackCount, forKey: .trackCount)
        try container.encodeIfPresent(copyright, forKey: .copyright)
        try container.encode(country, forKey: .country)
        try container.encode(currency, forKey: .currency)
        try container.encode(releaseDate, forKey: .releaseDate)
        try container.encode(primaryGenreName, forKey: .primaryGenreName)
        try container.encode(previewUrl, forKey: .previewUrl)
        try container.encode(description, forKey: .description)
    }
}

enum AudioType: String{
    case audiobook = "audiobook"
    case song = "track"
}
