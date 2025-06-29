//
//  Home.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/29.
//
import SwiftUI

struct HomeView<T: HomeViewModelProtocol>: View{
    @StateObject var vm: T
    @State var searchText: String = ""
    @FocusState private var isFocused: Bool
    var body: some View{
        NavigationStack {
            VStack{
                HStack{
                    Image(systemName: "magnifyingglass").renderingMode(.template).tint(.secondary).foregroundStyle(.secondary)
                    if #available(iOS 17.0, *) {
                        TextField("Search", text: $searchText).focused($isFocused)
                        
                        .onChange(of: searchText) { oldValue, newValue in
                            vm.searchTextValueChanged(to: newValue)
                        }
                    }else{
                        TextField("Search", text: $searchText).focused($isFocused)
                        
                        .onChange(of: searchText) { newValue in
                            vm.searchTextValueChanged(to: newValue)
                        }
                    }
                    Spacer()
                    if isFocused{
                        Text("Cancel").tint(.accentColor).onTapGesture {
                            isFocused = false
                            searchText = ""
                        }
                    }
                }.padding(.horizontal, 10)
                .onAppear(perform: {
                    vm.viewDidLoad()
                })
                if isFocused{
                    generateSearchContent()
                }else{
                    generateContent()
                }
            }
//            .sheet(item: $vm.selectedAudioToAdd, content: {
//                PlaylistModalView(playlists: $vm.playlists, actions: .init(addToPlaylist: { playlist in
//                    
//                }))
//            })
            .sheet(isPresented: $vm.shouldPresentPlaylistModal, content: {
                PlaylistModalView(playlists: $vm.playlists, actions: .init(addToPlaylist: { playlist in
                    vm.userChoosePlaylist(playlist: playlist)
                }))
            })
            .navigationBarTitleDisplayMode(.inline)
//FIXME: Focus state wont ever change inside a toolbar, who knows why
///https://stackoverflow.com/questions/74245149/focusstate-textfield-not-working-within-toolbar-toolbaritem
//            .toolbar{
//                ToolbarItem(placement: .principal) {
//                    HStack{
//                        Image(systemName: "magnifyingglass").renderingMode(.template).tint(.secondary).foregroundStyle(.secondary)
//                        if #available(iOS 17.0, *) {
//                            TextField("Search", text: $searchText).focused($isFocused)
//                            
//                            .onChange(of: searchText) { oldValue, newValue in
//                                vm.searchTextValueChanged(to: newValue)
//                            }
//                            .onChange(of: isFocused) { oldValue, newValue in
//                                if newValue{
//                                    vm.userWantsToType()
//                                }else{
//                                    vm.userCancelTyping()
//                                }
//                            }
//                        }else{
//                            TextField("Search", text: $searchText).focused($isFocused)
//                            
//                            .onChange(of: searchText) { newValue in
//                                vm.searchTextValueChanged(to: newValue)
//                            }
//                            .onChange(of: isFocused) { newValue in
//                                if newValue{
//                                    vm.userWantsToType()
//                                }else{
//                                    vm.userCancelTyping()
//                                }
//                            }
//                        }
//                        Spacer()
//                    }
//                }
//            }
        }
    }
    
    @ViewBuilder
    func generateSearchContent() -> some View{
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        VStack{
            if vm.isLoadingSearching{
                generateSearchContentLoading(columns: columns)
            }else{
                generateSearchContentResult(columns: columns)
            }
        }
    }
    
    @ViewBuilder
    func generateSearchContentResult(columns: [GridItem]) -> some View{
        ScrollView{
            LazyVGrid(columns: columns) {
                ForEach(0..<vm.audios.count, id: \.self){ index in
                    let audio = vm.audios[index]
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
                    }.contentShape(Rectangle()).onTapGesture {
                        vm.userClickRow(at: index)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func generateSearchContentLoading(columns: [GridItem]) -> some View{
        ScrollView{
            LazyVGrid(columns: columns) {
                ForEach(0..<10, id: \.self){ index in
                    VStack{
                        Color.gray
                            .frame(width: 150, height: 150)
                            .aspectRatio(contentMode: .fill)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .modifier(Shimmer())
                        Color.gray.frame(width: 150, height: 10, alignment: .leading)
                            .modifier(Shimmer())
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func generateContent() -> some View{
        VStack{
            if vm.isLoadingSearching{
                generateRowLoadingView()
            }else{
                generateRowView()
            }
        }
    }
    
    @ViewBuilder
    func generateRowLoadingView() -> some View{
        ForEach(0..<10, id: \.self){ index in
            HStack{
                Color.gray.aspectRatio(contentMode: .fit).frame(width: 50, height: 50).clipShape(RoundedRectangle(cornerRadius: 10))
                Color.gray
                    .frame(width: 100, height: 10)
                Spacer()
            }
            .modifier(Shimmer())
            .padding(.horizontal, 10)
        }
        Spacer()
    }
    
    @ViewBuilder
    func generateRowView() -> some View{
        GeometryReader{ geometry in
            ScrollView{
                ForEach(0..<vm.audios.count, id: \.self){ index in
                    let audio = vm.audios[index]
                    HStack{
                        HStack{
                            AsyncImage(url: URL(string: audio.artworkUrl100 ?? "")).aspectRatio(contentMode: .fit).frame(width: 50, height: 50).clipShape(RoundedRectangle(cornerRadius: 10))
                            HStack{
                                Text(audio.title)
                                    .lineLimit(1)
                                Spacer()
                            }
                            .frame(width: geometry.size.width * 0.7)
                        }
                        .contentShape(Rectangle()).onTapGesture {
                            vm.userClickRow(at: index)
                        }
                        Spacer()
                        if vm.audio?.id == audio.id{
                            Image(systemName: "waveform.path")
                        
                        }
                        Image(systemName:"plus").resizable().frame(width: 20, height: 20).contentShape(Rectangle())
                            .onTapGesture(perform: {
                                vm.userAddToPlaylist(audio: audio)
                            })
                    }
                    .padding(.horizontal, 10)
                }
                Spacer()
            }.frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}
