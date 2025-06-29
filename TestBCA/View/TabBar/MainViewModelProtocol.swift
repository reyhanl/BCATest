//
//  TabBarVMProtocol.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/29.
//

import Foundation

protocol MainViewModelProtocol: ObservableObject{
    var api: AudioAPIUseCaseProtocol{get set}
    var playerManager: AudioPlayerProtocol{get set}
    
    var audios: [Audio]{get set}
    var audio: Audio?{get set}
    var audioPlayerStatus: AudioPlayerStatus{get set}
    var thumbnailImage: String{get set}
    var title: String{get set}
    var currentDuration: Int{get set}
    var duration: Int{get set}
    var isLoadingSearching: Bool{get set}
    
    func viewDidLoad()
    func playPause()
    func pause()
    func play()
    func next()
    func previous()
    func seek(to duration: Int)
    func userClickRow(at: Int)
    func userWantsToType()
    func userCancelTyping()
    func searchTextValueChanged(to value: String)
    func search(text: String) async
}
