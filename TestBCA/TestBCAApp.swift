//
//  TestBCAApp.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/29.
//

import SwiftUI

@main
struct TestBCAApp: App {
    @State var testing: UITestingType = .testingUIError
    var body: some Scene {
        WindowGroup {
            ZStack{
                switch testing {
                case .testingUIError:
                    generateMainView()
                case .testingHomeViewDisplayingData:
                    generateTestingTapOnACellToPlayView()
                case .testingTapOnACellToPlay:
                    generateTestingTapOnACellToPlayView()
                case .testingPlayingTheFirstAudio:
                    generateTestingTapOnACellToPlayView()
                case .testingOpeningSearchingUI:
                    generateMainView()
                default:
                    generateMainView()
                }
            }.onAppear {
                if ProcessInfo.processInfo.arguments.contains("testingFailedToLoadAPIError"){
                    testing = .testingHomeViewDisplayingData
                }else if ProcessInfo.processInfo.arguments.contains("testingTapOnACellToPlay"){
                    testing = .testingTapOnACellToPlay
                }else if ProcessInfo.processInfo.arguments.contains(UITestingType.testingHomeViewDisplayingData.rawValue){
                    testing = .testingHomeViewDisplayingData
                }else if ProcessInfo.processInfo.arguments.contains(UITestingType.testingOpeningSearchingUI.rawValue){
                    testing = .testingOpeningSearchingUI
                }else if ProcessInfo.processInfo.arguments.contains(UITestingType.testingPlayingTheFirstAudio.rawValue){
                    testing = .testingPlayingTheFirstAudio
                }else{
                    testing = .none
                }
            }
        }
    }
    
    @ViewBuilder
    func generateTestingTapOnACellToPlayView() -> some View{
        MainView(
            vm: MainViewModel(
                api: DummyPersistenceUsecase(
                    persistence: AudioRemotePersistence()
                ),
                playerManager: AudioPlayerManager(
                    loader: AudioLoader(),
                    notificationManager: AudioPlayerNotificationManager()
                )
            ), testing: $testing)
    }
    
    @ViewBuilder
    func generateMainView() -> some View{
        MainView(
        vm: MainViewModel(
            api: AudioPersistenceUsecase(
                persistence: AudioRemotePersistence()
            ),
            playerManager: AudioPlayerManager(
                loader: AudioLoader(),
                notificationManager: AudioPlayerNotificationManager()
            )
        ), testing: $testing)
    }
            
}
