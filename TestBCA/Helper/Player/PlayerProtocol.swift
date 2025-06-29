//
//  Protoco.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/29.
//
import Foundation
import AVKit

protocol AudioPlayerProtocol: NSObject{
    var value: Int? { get set }
    var duration: Int?{get set}
    var delegate: AudioPlayerDelegate?{get set}
    func play()
    func play(audio: Audio, withPlaylist: [Audio])
    func pause()
    func seek(to: Int)
}

protocol AudioPlayerDelegate: NSObject{
    func updateDuration(currentValue: Int)
    func status(isPlaying: Bool)
}

protocol AudioLoaderProtocol{
    func loadAudio(url: String) -> AVPlayerItem?
}

protocol AudioProviderProtocol{
    var currentAudio: Audio?{get set}
    var audios: [Audio]{get set}
}

