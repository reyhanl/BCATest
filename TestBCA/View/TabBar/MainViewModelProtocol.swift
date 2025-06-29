//
//  TabBarVMProtocol.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/29.
//

protocol MainViewModelProtocol{
    var api: AudioAPIUseCaseProtocol{get set}
    var playerManager: AudioPlayerProtocol{get set}
}
