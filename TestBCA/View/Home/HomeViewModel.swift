//
//  HomeViewModel.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/30.
//

import SwiftUI
import AVKit

class HomeViewModel: NSObject, ObservableObject, HomeViewModelProtocol{
    @Published var currentDuration: Int = 0
    @Published var isLoadingSearching: Bool = false
    var api: AudioAPIUseCaseProtocol
    @Published var playerManager: AudioPlayerProtocol
    @Published var audios: [Audio] = []{
        didSet{
            print("count: \(audios.count)")
        }
    }
    @Published var audio: Audio?
    @Published var audioPlayerStatus: AudioPlayerStatus = .noAudioIsSelected
    @Published var searchText: String = ""
    
    let debouncer: Debouncer = Debouncer(interval: 1)
    
    init(api: AudioAPIUseCaseProtocol, playerManager: AudioPlayerProtocol) {
        self.api = api
        self.playerManager = playerManager
        super.init()
    }
    
    func viewDidLoad(){
        addObserver()
        Task{
            let audios = try await fetchData()
            await MainActor.run {
                self.audios = audios
            }
        }
    }
    
    func addObserver(){
        playerManager.notificationManager.addObserver(to: self)
    }
    
    func fetchData() async throws -> [Audio]{
        await MainActor.run {
            self.isLoadingSearching = true
        }
        do{
            let audios = try await api.loadAudio(keyword: nil)
            await MainActor.run {
                self.isLoadingSearching = false
            }
            return audios
        }catch{
            print("error: \(String.init(describing: error))")
            throw error
        }
    }
    
    func userClickRow(at: Int){
        let audio = audios[at]
        playerManager.play(audio: audio, withPlaylist: audios)
    }
    
    func searchTextValueChanged(to value: String){
        debouncer.debounce { [weak self] in
            Task{
                await self?.search(text: value)
            }
        }
    }
    
    func search(text: String) async{
        await MainActor.run {
            self.isLoadingSearching = true
        }
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
}

extension HomeViewModel: AudioNotificationManagerDelegate{
    @objc func didChangeAudio(_ notification: Notification) {
        if let audio = notification.object as? Audio{
            self.audio = audio
        }
    }
    
    @objc func updateTime(_ notification: Notification) {
        print("update time is called")
        if let duration = notification.object as? AudioDurationUpdate{
        }
    }
    
    @objc func status(_ notification: Notification) {
        print("status update is called")
        if let status = notification.object as? AudioPlayerStatus{
//            if self.audioPlayerStatus == .noAudioIsSelected{
//                withAnimation {
//                    self.audioPlayerStatus = status
//                }
//            }else{
//                self.audioPlayerStatus = status
//            }
        }
    }
}

