//
//  PlaylistViewModelProtocol.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/30.
//

import Foundation

protocol PlaylistViewModelProtocol: ObservableObject{
    var api: PlaylistAPIUseCaseProtocol{get set}
    var playerManager: AudioPlayerProtocol{get set}
    
    var playlists: [PlaylistModel]{get set}
    var audio: Audio?{get set}
    var audioPlayerStatus: AudioPlayerStatus{get set}
    var isLoadingPlaylist: Bool{get set}
    var isPresentAddPlaylistView: Bool{get set}
    var expandedPlaylist: PlaylistModel?{get set}
    var playingPlaylist: PlaylistModel?{get set}
    
    func viewDidLoad()
    func userClickPlaylist(playlist: PlaylistModel)
    func fetchPlaylists() async throws -> [PlaylistModel]
    func shouldPresentAddPlaylistView()
    func addPlaylist(name: String)
}
