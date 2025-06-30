//
//  PlaylistView.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/29.
//

import SwiftUI

struct PlaylistView<T: PlaylistViewModelProtocol>: View {
    @StateObject var vm: T
    var body: some View {
        NavigationView{
            VStack{
                VStack{
                    ScrollView{
                        ForEach(0..<vm.playlists.count, id: \.self){ index in
                            let playlist = vm.playlists[index]
                            HStack{
                                Text(playlist.playlistName)
                                Spacer()
                                PlaylistThumbnailView(audios: $vm.playlists[index].audios)
                            }.padding(.horizontal, 10).contentShape(Rectangle()).onTapGesture {
                                vm.userClickPlaylist(playlist: playlist)
                            }
                        }
                    }
                }
            }.onAppear {
                vm.viewDidLoad()
            }
        }
    }
}
