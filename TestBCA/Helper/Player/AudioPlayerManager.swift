//
//  AudioManager.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/29.
//
import AVKit

class AudioPlayerManager: NSObject, ObservableObject, AudioPlayerProtocol{
    var currentAudio: Audio?
    var playlist: [Audio] = []
    var player: AVPlayer?
    var value: Int?
    var duration: Int?
    var audioLoader: AudioLoaderProtocol
    var notificationManager: AudioPlayerNotificationManagerProtocol
    var status: AudioPlayerStatus = .noAudioIsSelected
    var timer: Timer?
    var observer:Any?
    
    init(loader: AudioLoaderProtocol, notificationManager: AudioPlayerNotificationManager) {
        self.audioLoader = loader
        self.notificationManager = notificationManager
    }
    
    func play() {
        if let player = player{
            player.play()
        }
    }
    
    func play(audio: Audio, withPlaylist: [Audio] = []) {
        player?.pause()
        notificationManager.status(status: .isLoading)
        resetStatManually()
        guard let item = audioLoader.loadAudio(url: audio.previewUrl ?? "")
        else{
            notificationManager.status(status: .failedToLoad)
            return
        }
        self.currentAudio = audio
        self.playlist = withPlaylist
        notificationManager.didChangeAudio(audio: audio)
        player = AVPlayer(playerItem: item)
        player?.play()
        notificationManager.status(status: .isLoading)
//        player?.addObserver(self, forKeyPath: "rate", options: [], context: nil)
        
        //TODO: Find a way to optimize this
        observer = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: .main) { [weak self] time in
                if self?.player?.timeControlStatus == .playing {
                    self?.notificationManager.status(status: .isPlaying)
                    self?.updateDuration()
                    self?.checkDuration()
                    self?.status = .isPlaying
                } else if self?.player?.timeControlStatus == .paused {
                    self?.notificationManager.status(status: .isPaused)
                    self?.updateDuration()
                    self?.status = .isPaused
                } else if self?.player?.timeControlStatus == .waitingToPlayAtSpecifiedRate {
                    self?.status = .isLoading
                    self?.notificationManager.status(status: .isLoading)
                    self?.notificationManager.updateTime(currentPlaybackTime: 0, totalDuration: 0)
                }

            }
    }
    
    func pause() {
        player?.pause()
    }
    
    func seek(to: Int) {
        player?.seek(to: CMTime(seconds: Double(to), preferredTimescale: 1000))
        player?.play()
    }
    
    private func resetStatManually(){
        value = 0
        duration = 0
    }
    
    private func startObservingTime(){
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            self?.updateDuration()
        }
    }
    
    private func stopObservingTime(){
        timer?.invalidate()
        timer = nil
    }
    
    func next(){
        if let id = currentAudio?.id,
           let index = playlist.firstIndex(where: {$0.id == id}),
           index < playlist.count - 1
        {
            let tempIndex = index + 1
            let audio = playlist[tempIndex]
            play(audio: audio, withPlaylist: playlist)
        }
    }
    
    func previous() {
        if let id = currentAudio?.id,
           let index = playlist.firstIndex(where: {$0.id == id}),
           index > 0
        {
            let tempIndex = index - 1
            let audio = playlist[tempIndex]
            play(audio: audio, withPlaylist: playlist)
        }
    }
    
    func togglePlay() {
        if status == .isPaused{
            play()
        }else if status == .isPlaying{
            pause()
        }
    }
    
    private func checkDuration(){
        let playbackTime = Int(player?.currentTime().seconds ?? 0)
        let tempDuration = player?.currentItem?.duration.seconds ?? 0
        guard tempDuration.isFinite else {return}
        let duration = Int(tempDuration)
        value = Int(player?.currentTime().seconds ?? 0)
        self.duration = Int(player?.currentItem?.duration.seconds ?? 0)
        if duration <= value ?? 0{
            next()
        }
    }
    
    private func updateDuration(){
        let playbackTime = Int(player?.currentTime().seconds ?? 0)
        let tempDuration = player?.currentItem?.duration.seconds ?? 0
        guard tempDuration.isFinite else {return}
        let duration = Int(tempDuration)
        value = Int(player?.currentTime().seconds ?? 0)
        self.duration = Int(player?.currentItem?.duration.seconds ?? 0)
        print("duration: \(duration)")
        DispatchQueue.main.async { [weak self] in
            self?.notificationManager.updateTime(currentPlaybackTime: playbackTime, totalDuration: duration)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == "rate", let player = object as? AVPlayer {
//            if player.rate == 1 {
//                delegate?.status(status: .isPlaying)
//            } else {
//                delegate?.status(status:.isPaused)
//                stopObservingTime()
//            }
//        }else if keyPath == "timeControlStatus", let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
//            if #available(iOS 10.0, *) {
//                let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
//                let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
////                if newStatus != oldStatus {
//                   DispatchQueue.main.async {[weak self] in
//                       if newStatus == .playing || newStatus == .paused {
//                           if newStatus == .playing{
//                               self?.startObservingTime()
//                           }else{
//                               self?.stopObservingTime()
//                               self?.updateDuration()
//                           }
////                           self?.delegate?.status(status: newStatus == .playing ? .isPlaying:.isPaused)
//                       } else {
//                           self?.delegate?.status(status:.isLoading)
//                           self?.resetStatManually()
//                       }
//                   }
////                }
//            }
//        }
    }
}

class AudioPlayerNotificationManager: AudioPlayerNotificationManagerProtocol{
    
    func addObserver(to delegate: any AudioNotificationManagerDelegate){
        NotificationCenter.default.addObserver(delegate, selector: #selector(delegate.didChangeAudio(_:)), name: .didChangeAudio, object: nil)
        NotificationCenter.default.addObserver(delegate, selector: #selector(delegate.updateTime(_:)), name: .updateTime, object: nil)
        NotificationCenter.default.addObserver(delegate, selector: #selector(delegate.status(_:)), name: .status, object: nil)
    }
    
    func didChangeAudio(audio: Audio){
        NotificationCenter.default.post(name: .didChangeAudio, object: audio)
    }
    func updateTime(currentPlaybackTime: Int, totalDuration: Int){
        NotificationCenter.default.post(name: .updateTime, object: AudioDurationUpdate(currentDuration: currentPlaybackTime, totalDuration: totalDuration))
    }
    func status(status: AudioPlayerStatus){
        NotificationCenter.default.post(name: .status, object: status)
    }
}

struct AudioDurationUpdate{
    var currentDuration: Int
    var totalDuration: Int
}

@objc protocol AudioNotificationManagerDelegate: AnyObject {
    @objc func didChangeAudio(_ notification: Notification)
    @objc func updateTime(_ notification: Notification)
    @objc func status(_ notification: Notification)
}

protocol AudioPlayerNotificationManagerProtocol{
    func addObserver(to delegate: any AudioNotificationManagerDelegate)
    func didChangeAudio(audio: Audio)
    func updateTime(currentPlaybackTime: Int, totalDuration: Int)
    func status(status: AudioPlayerStatus)
}
