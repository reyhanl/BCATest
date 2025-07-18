//
//  ContentView.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/29.
//

import SwiftUI
import AVKit
import CoreData

enum TabBarMenu{
    case home
    case playlist
}

struct MainView<T: MainViewModelProtocol>: View {
    @ObservedObject var vm: T
    @State var safeAreaBottom: CGFloat = 0
    @State var selectedMenu: TabBarMenu = .home
    @Binding var testing: UITestingType
    let helper = CoreDataHelper(stack: .init(name: "Data"))
    var body: some View {
        ZStack{
            TabView(selection: $selectedMenu){
                    ZStack{
                        GeometryReader{ geometry in
                            switch testing {
                            case .testingTapOnACellToPlay, .testingHomeViewDisplayingData,
                                    .testingOpeningSearchingUI,
                                    .testingPlayingTheFirstAudio
                                :
                                HomeView(
                                    vm: HomeViewModel(
                                        api: AudioPersistenceUsecase(persistence: MockHomePersistence()),
                                        playlistAPI: PlaylistPersistenceUsecase(persistence: PlaylistLocalPersistence(helper: helper, entityName: "Playlist")),
                                        playerManager: vm.playerManager
                                    )
                                )
                                    .frame(width: geometry.size.width, height: geometry.size.height)
                                    .onAppear {
                                    safeAreaBottom = geometry.safeAreaInsets.bottom
                                }
                            default:
                                HomeView(
                                    vm: HomeViewModel(
                                        api: AudioPersistenceUsecase(persistence: AudioRemotePersistence()),
                                        playlistAPI: PlaylistPersistenceUsecase(persistence: PlaylistLocalPersistence(helper: helper, entityName: "Playlist")),
                                        playerManager: vm.playerManager
                                    )
                                )
                                    .frame(width: geometry.size.width, height: geometry.size.height)
                                    .onAppear {
                                    safeAreaBottom = geometry.safeAreaInsets.bottom
                                }
                            }
                        }
                    }.tabItem {
                        Image(systemName: selectedMenu == .home ? "house.fill" : "house")
                        Text("Home")
                    }.tag(TabBarMenu.home)
                PlaylistView(vm: PlaylistViewModel(api: PlaylistPersistenceUsecase(persistence: PlaylistLocalPersistence(helper: helper, entityName: "Playlist")), playerManager: vm.playerManager))
                    .tabItem {
                        Image(systemName: selectedMenu == .home ? "list.bullet.clipboard.fill" : "list.bullet.clipboard")
                        Text("Playlists")
                    }.tag(TabBarMenu.playlist)
            }
            VStack{
                Spacer()
                if vm.audioPlayerStatus != .noAudioIsSelected{
                    PlayerView(
                        value: $vm.currentDuration,
                        duration: $vm.duration,
                        thumbnailImage: $vm.thumbnailImage,
                        title: $vm.title,
                        status: $vm.audioPlayerStatus,
                        isPreviousSongAvailable: $vm.isPreviousSongAvailable,
                        isNextSongAvailable: $vm.isNextSongAvailable,
                        actions: .init(next: {
                            vm.next()
                        }, playPause: {
                            vm.playPause()
                        }, play: {
                            vm.play()
                        }, pause: {
                            vm.pause()
                        }, previous: {
                            vm.previous()
                        }, seek: { time in
                            vm.seek(to: time)
                        })
                    )
                        .frame(height: 50)
                        .padding(.bottom, safeAreaBottom)
                        .padding(.horizontal, 10)
                        .transition(.move(edge: .bottom))
                    
                }
                if let error = vm.errorMessage{
                    HStack{
                        Spacer()
                        Text(error).font(.system(size: 12)).bold().foregroundStyle(.white)
                        Spacer()
                    }
                    .frame(height: 50)
                    .background(Color(UIColor.init(red: 171/255, green: 65/255, blue: 65/255, alpha: 1)))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal, 10)
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut, value: vm.shouldDisplayError)
                }
            }
        }.onAppear {
            vm.viewDidLoad()
        }
    }
}

#Preview {
    MainView(vm: MainViewModel(api: AudioPersistenceUsecase(persistence: AudioRemotePersistence()), playerManager: AudioPlayerManager(loader: AudioLoader(), notificationManager: AudioPlayerNotificationManager())), testing: .constant(.none))
}
