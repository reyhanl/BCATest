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
    @Published var isPreviousSongAvailable: Bool = false
    @Published var isNextSongAvailable: Bool = false
    var api: AudioAPIUseCaseProtocol
    @Published var playerManager: AudioPlayerProtocol
    @Published var audios: [Audio] = []
    @Published var audio: Audio?
    @Published var audioPlayerStatus: AudioPlayerStatus = .noAudioIsSelected
    
    @Published var searchText: String = ""
    @Published var errorMessage: String?
    @Published var shouldDisplayError: Bool = false
    
    let debouncer: Debouncer = Debouncer(interval: 1)
    
    init(api: AudioAPIUseCaseProtocol, playerManager: AudioPlayerProtocol) {
        self.api = api
        self.playerManager = playerManager
        super.init()
    }
    
    func viewDidLoad(){
        addObserver()
    }
    
    func addObserver(){
        playerManager.notificationManager.addObserver(to: self)
        NotificationCenter.default.addObserver(self, selector: #selector(displayError(_:)), name: .errorGan, object: nil)
    }
    
    func fetchData() async throws -> [Audio]{
        do{
            let audios = try await api.loadAudio(keyword: nil)
            return audios
        }catch{
            print("error: \(String.init(describing: error))")
            throw error
        }
    }
    
    func userClickRow(at: Int){
        let audio = audios[at]
        playerManager.play(audio: audio, withPlaylist: .init(id: "-1", title: "home", audios: .init(audios: audios)))
    }
    
    func searchTextValueChanged(to value: String){
        debouncer.debounce { [weak self] in
            Task{
                await self?.search(text: value)
            }
        }
    }
    
    func search(text: String) async{
        self.isLoadingSearching = true
        do{
            let audios = try await self.api.loadAudio(keyword: text)
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
    
    func userWantsToType() {
        
    }
    
    func userCancelTyping() {
        
    }
}

//MARK: Playback Control
extension MainViewModel{
    func next(){
        try? playerManager.next()
    }
    
    func previous(){
        try? playerManager.previous()
    }
    
    func playPause(){
        playerManager.togglePlay()
    }
    
    func pause(){
        playerManager.pause()
    }
    
    func play(){
        playerManager.play()
    }
    
    func seek(to duration: Int) {
        playerManager.seek(to: duration)
    }
    
    func updatePlaybackButtonStatus(audio: Audio, playlist: PlaylistModel?){
        if let playlist = playlist{
            if let index = playlist.audios.audios.firstIndex(where: { $0.id == audio.id }){
                isPreviousSongAvailable = index > 0
                isNextSongAvailable = index < playlist.audios.audios.count - 1
            }else{
                isPreviousSongAvailable = false
                isNextSongAvailable = false
            }
        }else{
            isPreviousSongAvailable = false
            isNextSongAvailable = false
        }
    }
    
    @objc func displayError(_ notification: Notification) {
        if let error = notification.object as? CustomError{
            Task{
                await MainActor.run {
                    withAnimation {
                        errorMessage = error.friendlyMessage
                        shouldDisplayError = true
                    }
                }
                try await Task.sleep(nanoseconds: 2_000_000_000)
                await MainActor.run {
                    withAnimation {
                        shouldDisplayError = false
                    }
                }
                await MainActor.run {
                    errorMessage = nil
                }
            }
        }
    }
}

extension MainViewModel: AudioNotificationManagerDelegate{
    @objc func didChangeAudio(_ notification: Notification) {
        if let audio = notification.object as? Audio{
            self.audio = audio
            self.thumbnailImage = audio.artworkUrl100 ?? ""
            self.title = audio.title
            updatePlaybackButtonStatus(audio: audio, playlist: playerManager.playlist)
        }
    }
    
    @objc func updateTime(_ notification: Notification) {
        print("update time is called")
        if let duration = notification.object as? AudioDurationUpdate{
            self.currentDuration = duration.currentDuration
            self.duration = duration.totalDuration
        }
    }
    
    @objc func status(_ notification: Notification) {
        print("status update is called")
        if let status = notification.object as? AudioPlayerStatus{
            if self.audioPlayerStatus == .noAudioIsSelected{
                withAnimation {
                    self.audioPlayerStatus = status
                }
            }else{
                self.audioPlayerStatus = status
            }
        }
    }
}
