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
            MainView(
                vm: MainViewModel(
                    api: AudioPersistenceUsecase(
                        persistence: AudioRemotePersistence()
                    ),
                    playerManager: AudioPlayerManager(
                        loader: AudioLoader(),
                        notificationManager: AudioPlayerNotificationManager()
                    )
                )
            )
        }
    }
}
