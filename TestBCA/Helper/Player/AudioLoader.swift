//
//  Player.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/29.
//

import AVKit
import CoreData

class AudioLoader: AudioLoaderProtocol{
    func loadAudio(url: String) -> AVPlayerItem?{
        guard let url = URL(string: url) else{return nil}
        return AVPlayerItem(url: url)
    }
}
