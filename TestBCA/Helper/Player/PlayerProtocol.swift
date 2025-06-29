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
    var playlist: PlaylistModel?{get set}
    var notificationManager: AudioPlayerNotificationManagerProtocol{get set}
    func play()
    func play(audio: Audio, withPlaylist: PlaylistModel)
    func pause()
    func next() throws
    func previous() throws
    func togglePlay()
    func seek(to: Int)
}

protocol AudioPlayerDelegate: NSObject{
    func didChangeAudio(audio: Audio)
    func updateTime(currentPlaybackTime: Int, totalDuration: Int)
    func status(status: AudioPlayerStatus)
}

enum AudioPlayerStatus{
    case isLoading
    case failedToLoad
    case noAudioIsSelected
    case isPlaying
    case isPaused
}

protocol AudioLoaderProtocol{
    func loadAudio(url: String) -> AVPlayerItem?
}

protocol AudioProviderProtocol{
    var currentAudio: Audio?{get set}
    var audios: [Audio]{get set}
}

