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
    var audioPlayerStatus: AudioPlayerStatus{get set}
    var thumbnailImage: String{get set}
    var title: String{get set}
    var searchText: String{get set}
    var currentDuration: Int{get set}
    var duration: Int{get set}
    
    func viewDidLoad()
    func playPause()
    func next()
    func previous()
    func userClickRow(at: Int)
}
