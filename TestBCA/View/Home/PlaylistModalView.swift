//
//  PlaylistModalView.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/30.
//
import SwiftUI

struct PlaylistModalView: View {
    @Binding var playlists: [PlaylistModel]
    
    var actions: Action
    struct Action{
        var addToPlaylist: (PlaylistModel) -> Void
    }
    var body: some View {
            VStack{
                HStack{
                    Text("Add song to Playlist").font(.system(.headline))
                    Spacer()
                }.padding(.top, 20).padding(.horizontal, 10)
                ScrollView{
                    ForEach(0..<playlists.count, id: \.self){ index in
                        HStack{
                            Group{
                                ZStack{
                                    HStack{
                                        Text(playlists[index].playlistName).lineLimit(1)
                                        Spacer()
                                    }
                                    HStack{
                                        Spacer()
                                        PlaylistThumbnailView(audios: $playlists[index].audios)
                                    }
                                }
                            }
                            .padding(.horizontal, 10)
                        }
                        .background(Color.secondary.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .contentShape(Rectangle())
                        
                        .onTapGesture(perform: {
                            actions.addToPlaylist(playlists[index])
                        })
                        .padding(.horizontal, 10)
                    }
                }
            }
    }
}
