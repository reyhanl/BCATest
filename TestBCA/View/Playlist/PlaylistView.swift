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
                                PlaylistThumbnailView(audios: $vm.playlists[index].audios).padding(.trailing, 25)
                                let isPlaying: Bool = vm.playingPlaylist?.id == playlist.id
                                if isPlaying{
                                    Image(systemName: "waveform.path").resizable().tint(.blue).foregroundStyle(.blue).frame(width: 20, height: 20)
                                }else{
                                    Image(systemName: "play.fill").resizable().frame(width: 20, height: 20).contentShape(Rectangle())
                                        .onTapGesture {
                                            vm.userClickPlaylist(playlist: playlist)
                                        }
                                }
                            }.padding(.horizontal, 10).contentShape(Rectangle()).onTapGesture {
                                vm.expandedPlaylist = playlist
                            }
                        }
                    }
                }
            }
            .overlay(content: {
                if vm.isPresentAddPlaylistView{
                ZStack{
                    Color.black.opacity(0.2).onTapGesture {
                        vm.isPresentAddPlaylistView = false
                    }
                        AlertTextFieldView(isPresented: $vm.isPresentAddPlaylistView, action: .init(didTapYes: { text in
                            vm.addPlaylist(name: text)
                        }, didTapNo: {
                            vm.isPresentAddPlaylistView = false
                        }))
                    }
                }
            })
            .sheet(item: $vm.expandedPlaylist, content: { item in
                let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
                GeometryReader{ geometry in
                    ScrollView{
                        LazyVGrid(columns: columns) {
                            ForEach(0..<(vm.expandedPlaylist?.audios.audios.count ?? 0), id: \.self){ index in
                                if let audios = vm.expandedPlaylist?.audios.audios{
                                    let audio = audios[index]
                                    VStack{
                                        AsyncImage(url: URL(string: audio.artworkUrl100 ?? "")){ result in
                                                    result.image?
                                                        .resizable()
                                                        .scaledToFill()
                                                }
                                            .frame(width: 150, height: 150)
                                            .aspectRatio(contentMode: .fill)
                                            .overlay {
                                                if vm.audio?.id == audio.id{
                                                    ZStack{
                                                        Color.black.opacity(0.3)
                                                        Image(systemName: "waveform.path").resizable().tint(.white).foregroundStyle(.white).frame(width: 100, height: 100)
                                                    }
                                                }
                                            }
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                        Text(audio.title)
                                            .lineLimit(1)
                                    }
                                }
                                }
                        }
                        .frame(width: geometry.size.width)
                        .onDisappear {
                        }
                    }.frame(width: geometry.size.width, height: geometry.size.height)
                }

            })
            .onAppear {
                vm.viewDidLoad()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Playlist").font(.system(size: 15, weight: .bold))
                }
                ToolbarItem(placement: .primaryAction) {
                    Image(systemName: "plus").resizable().frame(width: 20, height: 20).onTapGesture {
                        vm.shouldPresentAddPlaylistView()
                    }
                }
            }
        }
    }
}

struct AlertTextFieldView: View {
    @Binding var isPresented: Bool
    @State private var textFieldValue: String = ""
    var action: Actions

    struct Actions{
        var didTapYes: (String) -> Void
        var didTapNo: () -> Void
    }
    var body: some View {
        VStack(spacing: 20) {
            Text("Playlist Name")
                .font(.headline)

            TextField("Vibing", text: $textFieldValue)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            HStack {
                Button("Cancel") {
                    isPresented = false
                    action.didTapNo()
                }
                .foregroundColor(.red)

                Spacer()

                Button("Add") {
                    isPresented = false
                    action.didTapYes(textFieldValue)
                }
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 10)
        .padding()
    }
}
