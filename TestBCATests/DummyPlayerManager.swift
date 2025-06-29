//
//  DummyPlayerView.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/29.
//

import Foundation

class DummyPlayerManager: NSObject, ObservableObject, AudioPlayerProtocol{
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
