//
//  Home.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/29.
//
import SwiftUI

struct HomeView: View{
    @EnvironmentObject var vm: MainViewModel
    
    var body: some View{
        ZStack{
            VStack{
                ScrollView{
                    ForEach(0..<vm.audios.count, id: \.self){ index in
                        let audio = vm.audios[index]
                        HStack{
                            AsyncImage(url: URL(string: audio.artworkUrl100 ?? "")).aspectRatio(contentMode: .fit).frame(width: 50, height: 50).clipShape(RoundedRectangle(cornerRadius: 10))
                            Text("text")
                            Spacer()
                        }.contentShape(Rectangle()).onTapGesture {
                            vm.userClickRow(at: index)
                        }
                    }
                }
                Spacer()
            }
        }
    }
}
