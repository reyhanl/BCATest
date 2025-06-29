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
    var body: some View {
        ZStack{
            TabView(selection: $selectedMenu){
                    ZStack{
                        GeometryReader{ geometry in
                            HomeView<T>()
                                .environmentObject(vm)
                                .frame(width: geometry.size.width, height: geometry.size.height).onAppear {
                                safeAreaBottom = geometry.safeAreaInsets.bottom
                            }
                        }
                    }.tabItem {
                    Image(systemName: selectedMenu == .home ? "house.fill" : "house")
                    Text("Home")
                }.tag(TabBarMenu.home)
                PlaylistView()
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
                        actions: .init(next: {
                            vm.next()
                        }, playPause: {
                            vm.playPause()
                        }, previous: {
                            vm.previous()
                        }, seek: { _ in
                            
                        })
                    )
                        .frame(height: 50)
                        .padding(.bottom, safeAreaBottom)
                        .padding(.horizontal, 10)
                        .transition(.move(edge: .bottom))
                }
            }
        }.onAppear {
            vm.viewDidLoad()
        }
    }
}

#Preview {
    MainView(vm: MainViewModel(api: AudioPersistenceUsecase(persistence: AudioRemotePersistence()), playerManager: AudioPlayerManager(loader: AudioLoader())))
}
