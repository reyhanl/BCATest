//
//  HomeViewModelProtocol.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/30.
//
import Foundation

protocol HomeViewModelProtocol: ObservableObject{
    var api: AudioAPIUseCaseProtocol{get set}
    var playerManager: AudioPlayerProtocol{get set}
    
    var audios: [Audio]{get set}
    var audio: Audio?{get set}
    var audioPlayerStatus: AudioPlayerStatus{get set}
    var isLoadingSearching: Bool{get set}
    
    func viewDidLoad()
    func userClickRow(at: Int)
    func searchTextValueChanged(to value: String)
    func search(text: String) async
    func userAddToPlaylist(audio: Audio)
}
