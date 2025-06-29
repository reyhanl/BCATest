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
