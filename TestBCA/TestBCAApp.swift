//
//  TestBCAApp.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/29.
//

import SwiftUI

@main
struct TestBCAApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(vm: PlayerViewModel(api: AudioPersistenceUsecase(persistence: AudioRemotePersistence()), playerManager: AudioPlayerManager(loader: AudioLoader(), provider: AudioProvider(audios: []))))
        }
    }
}
