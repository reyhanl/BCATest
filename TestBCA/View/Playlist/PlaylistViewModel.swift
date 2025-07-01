//
//  PlaylistViewModel.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/30.
//
import SwiftUI

class PlaylistViewModel: ObservableObject, PlaylistViewModelProtocol {
    var api: any PlaylistAPIUseCaseProtocol
    var playerManager: any AudioPlayerProtocol
    
    @Published var playlists: [PlaylistModel] = []
    @Published var audio: Audio?
    @Published var audioPlayerStatus: AudioPlayerStatus = .noAudioIsSelected
    @Published var isLoadingPlaylist: Bool = false
    
    init(api: any PlaylistAPIUseCaseProtocol, playerManager: any AudioPlayerProtocol) {
        self.api = api
        self.playerManager = playerManager
    }
    
    func viewDidLoad() {
        Task{ [weak self] in
            guard let self = self else{return}
            do{
                let playlist = try await fetchPlaylists()
                await MainActor.run{
                    self.playlists = playlist
                }
            }catch{
                print("error: \(error.localizedDescription)")
            }
        }
    }

    func userClickPlaylist(playlist: PlaylistModel){
        guard let audio = playlist.audios.audios.first else{
            return
        }
        playerManager.play(audio: audio, withPlaylist: playlist)
    }
    
    func fetchPlaylists() async throws -> [PlaylistModel] {
        await MainActor.run{
            isLoadingPlaylist = true
        }
        let data = try await api.loadAllPlaylist()
        await MainActor.run{
            isLoadingPlaylist = false
        }
        return data
    }
    
}
