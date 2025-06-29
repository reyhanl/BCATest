//
//  AudioManager.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/29.
//
import AVKit

class AudioPlayerManager: NSObject, ObservableObject, AudioPlayerProtocol{
    var player: AVPlayer?
    var value: Int?
    var duration: Int?
    var audioLoader: AudioLoaderProtocol
    var audioProvider: AudioProviderProtocol
    weak var delegate: AudioPlayerDelegate?
    
    init(loader: AudioLoaderProtocol, provider: AudioProviderProtocol) {
        self.audioLoader = loader
        self.audioProvider = provider
    }
    
    func play() {
        if let player = player, let audio = audioProvider.currentAudio{
            player.play()
            delegate?.status(isPlaying: true)
        }
    }
    
    func play(audio: Audio, withPlaylist: [Audio] = []) {
        audioProvider.currentAudio = audio
        audioProvider.audios = withPlaylist
        guard let audio = audioProvider.currentAudio,
              let item = audioLoader.loadAudio(url: audio.previewUrl)
        else{return}
        player = AVPlayer(playerItem: item)
        player?.play()
        player?.addObserver(self, forKeyPath: "rate", options: [], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "rate", let player = object as? AVPlayer {
            if player.rate == 1 {
                delegate?.status(isPlaying: true)
            } else {
                delegate?.status(isPlaying: false)
            }
        }
    }
    
    func pause() {
        player?.pause()
        delegate?.status(isPlaying: false)
    }
    
    func seek(to: Int) {
        
    }
}

