//
//  AudioProvider.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/29.
//
import Foundation

class AudioProvider: AudioProviderProtocol{
    var audios: [Audio]
    var currentAudio: Audio?
    
    init(audios: [Audio], currentAudio: Audio? = nil) {
        self.audios = audios
        self.currentAudio = currentAudio
    }
}
