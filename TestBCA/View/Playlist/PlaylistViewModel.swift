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
    @Published var isPresentAddPlaylistView: Bool = false
    @Published var expandedPlaylist: PlaylistModel?
    @Published var playingPlaylist: PlaylistModel?
    
    init(api: any PlaylistAPIUseCaseProtocol, playerManager: any AudioPlayerProtocol) {
        self.api = api
        self.playerManager = playerManager
    }
    
    func viewDidLoad() {
        addObserver()
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
    
    func addObserver(){
        playerManager.notificationManager.addObserver(to: self)
    }
    
    func shouldPresentAddPlaylistView(){
        isPresentAddPlaylistView = true
    }
    
    func addPlaylist(name: String){
        let playlist = PlaylistModel(id: UUID().uuidString, title: name, audios: Audios(audios: []))
        Task{
            try await api.savePlaylist(playlist: playlist)
            let playlists = try await fetchPlaylists()
            await MainActor.run {
                self.playlists = playlists
            }
        }
    }

    func userClickPlaylist(playlist: PlaylistModel){
        guard let audio = playlist.audios.audios.first else{
            return
        }
        if playingPlaylist?.id == playlist.id{
            playerManager.pause()
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

extension PlaylistViewModel: AudioNotificationManagerDelegate{
    @objc func didChangeAudio(_ notification: Notification) {
        if let audio = notification.object as? Audio{
            self.audio = audio
            self.playingPlaylist = playerManager.playlist
        }
    }
    
    @objc func updateTime(_ notification: Notification) {
        print("update time is called")
    }
    
    @objc func status(_ notification: Notification) {
        print("status update is called")
    }
}
