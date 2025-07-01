//
//  Playlist.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/30.
//

struct PlaylistModel: Identifiable, Codable{
    var playlistName: String
    var id: String
    var audios: Audios
    
    init(id: String, title: String, audios: Audios) {
        self.audios = audios
        self.id = id
        self.playlistName = title
    }

    enum CodingKeys: String, CodingKey {
        case playlistName
        case id
        case audios
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        audios = try container.decode(Audios.self, forKey: .audios)
        id = try container.decode(String.self, forKey: .id)
        playlistName = try container.decode(String.self, forKey: .playlistName)
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(playlistName, forKey: .playlistName)
        try container.encode(audios, forKey: .audios)
    }
}

