//
//  TabBarVM.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/29.
//
import SwiftUI

class MainViewModel: NSObject, ObservableObject, MainViewModelProtocol{    
    @Published var currentDuration: Int = 0
    @Published var duration: Int = 10
    @Published var thumbnailImage: String = ""
    @Published var title: String = ""
    @Published var isLoadingSearching: Bool = false
    var api: AudioAPIUseCaseProtocol
    @Published var playerManager: AudioPlayerProtocol
    @Published var audios: [Audio] = []
    @Published var audio: Audio?
    @Published var audioPlayerStatus: AudioPlayerStatus = .noAudioIsSelected
    
    @Published var searchText: String = ""
    
    let debouncer: Debouncer = Debouncer(interval: 1)
    
    init(api: AudioAPIUseCaseProtocol, playerManager: AudioPlayerManager) {
        self.api = api
        self.playerManager = playerManager
        super.init()
        playerManager.delegate = self
    }
    
    func viewDidLoad(){
        self.isLoadingSearching = true
        Task{ [weak self] in
            guard let self = self else{return}
            do{
                let audios = try await api.loadAudio(keyword: "")
                await MainActor.run {
                    self.audios = audios
                    self.isLoadingSearching = false
                }
            }catch{
                await MainActor.run {
                    self.isLoadingSearching = false
                }
                print("error: \(String.init(describing: error))")
            }
        }
    }
    
    func userClickRow(at: Int){
        let audio = audios[at]
        playerManager.play(audio: audio, withPlaylist: audios)
    }
    
    func searchTextValueChanged(to value: String){
        debouncer.debounce { [weak self] in
            guard let self = self else{return}
            self.isLoadingSearching = true
            Task{
                do{
                    let audios = try await self.api.loadAudio(keyword: value)
                    await MainActor.run {
                        self.audios = audios
                        self.isLoadingSearching = false
                    }
                }catch{
                    await MainActor.run {
                        self.isLoadingSearching = false
                    }
                    print("error: \(String.init(describing: error))")
                }
            }
        }
    }
    
    func userWantsToType() {
        
    }
    
    func userCancelTyping() {
        
    }
}

//MARK: Playback Control
extension MainViewModel{
    func next(){
        playerManager.next()
    }
    
    func previous(){
        playerManager.previous()
    }
    
    func playPause(){
        playerManager.togglePlay()
    }
}

extension MainViewModel: AudioPlayerDelegate{
    func didChangeAudio(audio: Audio) {
        self.audio = audio
        self.thumbnailImage = audio.artworkUrl100 ?? ""
        self.title = audio.title
    }
    
    func updateTime(currentPlaybackTime: Int, totalDuration: Int) {
        self.currentDuration = currentPlaybackTime
        self.duration = totalDuration
    }
    
    func status(status: AudioPlayerStatus) {
        if self.audioPlayerStatus == .noAudioIsSelected{
            withAnimation {
                self.audioPlayerStatus = status
            }
        }else{
            self.audioPlayerStatus = status
        }
//        self.duration = Int(playerManager.player?.currentItem?.duration.seconds ?? 0)
    }
}
