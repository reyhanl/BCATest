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
        VStack{
            VStack{
                ForEach(0..<vm.playlists.count, id: \.self){ index in
                    let audio = vm.playlists[index]
                    HStack{
                        Text(audio.playlistName)
                        Spacer()
                        PlaylistThumbnailView(audios: $vm.playlists[index].audios)
                    }.padding(.horizontal, 10)
                }
            }
        }.onAppear {
            vm.viewDidLoad()
        }
    }
}
