//
//  DummyPlayerView.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/29.
//

import Foundation

class DummyPlayerManager: NSObject, ObservableObject, AudioPlayerProtocol{
    var playlist: PlaylistModel?
    
    var notificationManager: any AudioPlayerNotificationManagerProtocol
    
    init(notificationManager: any AudioPlayerNotificationManagerProtocol) {
        self.notificationManager = notificationManager
    }
    
    func play(audio: Audio, withPlaylist: PlaylistModel) {
        
    }
    
    var value: Int?
    
    var duration: Int?
    
    var delegate: (any AudioPlayerDelegate)?
    
    func play() {
            
    }
    
    func play(audio: Audio, withPlaylist: [Audio]) {
        
    }
    
    func pause() {
        
    }
    
    func next() {
        
    }
    
    func previous() {
        
    }
    
    func togglePlay() {
        
    }
    
    func seek(to: Int) {
        
    }
}
