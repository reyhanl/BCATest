//
//  Home.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/29.
//
import SwiftUI

struct HomeView<T: MainViewModelProtocol>: View{
    @EnvironmentObject var vm: T
    
    var body: some View{
        NavigationView {
            ZStack{
                VStack{
                    ScrollView{
                        ForEach(0..<vm.audios.count, id: \.self){ index in
                            let audio = vm.audios[index]
                            HStack{
                                AsyncImage(url: URL(string: audio.artworkUrl100 ?? "")).aspectRatio(contentMode: .fit).frame(width: 50, height: 50).clipShape(RoundedRectangle(cornerRadius: 10))
                                Text(audio.title).lineLimit(1)
                                Spacer()
                            }.contentShape(Rectangle()).onTapGesture {
                                vm.userClickRow(at: index)
                            }
                        }
                    }
                    Spacer()
                }
            }.toolbar {
                HStack{
                    TextField("Search", text: $vm.searchText)
                    Spacer()
                }
            }
        }
    }
}
