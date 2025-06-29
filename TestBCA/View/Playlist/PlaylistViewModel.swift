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
//                try await api.deleteAllPlaylist()
//                let audios = Audios(audios: generateDummyData())
//                let playlistModel = PlaylistModel(id: "2", title: "Cool", audios: audios)
//                let playlistModel2 = PlaylistModel(id: "1", title: "Buat bobo", audios: audios)
//                let playlistModel3 = PlaylistModel(id: "3", title: "Keren bangett", audios: audios)
//                try await api.savePlaylist(playlist: playlistModel)
//                try await api.savePlaylist(playlist: playlistModel2)
//                try await api.savePlaylist(playlist: playlistModel3)
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
                    artworkUrl100: "https://is1-ssl.mzstatic.com/image/thumb/Video113/v4/58/cd/27/58cd278f-8501-9240-dab9-893818292b75/pr_source.lsr/100x100bb.jpg",
                    previewUrl: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview116/v4/57/9d/9d/579d9db7-83a2-2e7a-875b-c7fa852653bf/mzaf_15730070059007636621.std.aac.p.m4a"
                ),
                Audio(
                    wrapperType: "audiobook",
                    id: 2001,
                    title: "The Art of Stillness",
                    artistName: "Pico Iyer",
                    artworkUrl100: "https://is1-ssl.mzstatic.com/image/thumb/Music113/v4/4e/3d/b6/4e3db6c4-ef22-0611-cfc9-e5d206c7da00/9780525638742.d.jpg/100x100bb.jpg",
                    previewUrl: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/a1/dc/9a/a1dc9a03-1bed-9b15-810a-007015043314/mzaf_14009218602239450570.std.aac.p.m4a"
                ),
                Audio(
                    wrapperType: "track",
                    id: 1002,
                    title: "Lo-fi Beats",
                    artistName: "Lo-Fi Producer",
                    artworkUrl100: "https://is1-ssl.mzstatic.com/image/thumb/Music114/v4/c0/60/4a/c0604a3a-ed6f-6827-47a2-d6262e778e09/9781549183911.jpg/100x100bb.jpg",
                    previewUrl: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview122/v4/52/9f/1e/529f1e0f-4457-2da1-949a-2b5c71523317/mzaf_13591425659715026900.std.aac.p.m4a"
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
