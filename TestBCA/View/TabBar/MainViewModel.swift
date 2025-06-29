//
//  TabBarVM.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/29.
//
import SwiftUI

class MainViewModel: NSObject, ObservableObject, MainViewModelProtocol{    
    @Published var value: Int = 0
    @Published var duration: Int = 10
    @Published var thumbnailImage: String = ""
    @Published var title: String = ""
    var api: AudioAPIUseCaseProtocol
    @Published var playerManager: AudioPlayerProtocol
    @Published var audios: [Audio] = []
    @Published var audioPlayerStatus: AudioPlayerStatus = .noAudioIsSelected
    
    init(api: AudioAPIUseCaseProtocol, playerManager: AudioPlayerManager) {
        self.api = api
        self.playerManager = playerManager
        super.init()
        playerManager.delegate = self
    }
    
    func viewDidLoad(){
        Task{
            do{
                let audios = try await api.loadAudio(keyword: "")
                await MainActor.run {
                    self.audios = audios
                }
            }catch{
                print("error: \(String.init(describing: error))")
            }
        }
    }
    
    func userClickRow(at: Int){
        let audio = audios[at]
        playerManager.play(audio: audio, withPlaylist: audios)
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
        self.thumbnailImage = audio.artworkUrl100 ?? ""
        self.title = audio.title
    }
    
    func updateTime(currentPlaybackTime: Int, totalDuration: Int) {
        self.value = currentPlaybackTime
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
