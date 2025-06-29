//
//  TestingComponentView.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/29.
//
import SwiftUI

struct AudioListView: View{
    
    var body: some View{
        ZStack{
            VStack{
                Spacer()
            }
        }
    }
}

protocol PlayerViewModelProtocol{
    var api: AudioPersistenceUsecase{get set}
    var playerManager: AudioPlayerManager{get set}
}

class PlayerViewModel: ObservableObject{
    @Published var value: Int = 0
    @Published var duration: Int = 10
    var api: AudioPersistenceUsecase
    var playerManager: AudioPlayerManager
    
    init(api: AudioPersistenceUsecase, playerManager: AudioPlayerManager) {
        self.api = api
        self.playerManager = playerManager
    }
    
    func viewDidLoad(){
        Task{
            let audios = try await api.loadAudio()
        }
    }
}

struct PlayerView: View {
    @Binding var value: Int
    @Binding var duration: Int
    var body: some View {
        HStack{
            Text("test")
            SliderView(value: $value, duration: $duration).frame(height: 50)
            Text("test")
        }
    }
}

struct SliderView: View {
    @Binding var value: Int
    @Binding var duration: Int
    var body: some View {
        HStack{
            GeometryReader{ geometry in
                HStack{
                    Color.black.frame(width: CGFloat(value) / CGFloat(duration) * geometry.size.width)
                    Spacer()
                }.frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}
