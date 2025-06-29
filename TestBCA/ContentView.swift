//
//  ContentView.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/29.
//

import SwiftUI
import AVKit
import CoreData

struct ContentView: View {
    @ObservedObject var vm: PlayerViewModel
    @State var safeAreaBottom: CGFloat = 0
    var body: some View {
        ZStack{
            TabView{
                Tab("Home", systemImage: ""){
                    GeometryReader{ geometry in
                        ZStack{
                            AudioListView()
                        }.frame(width: geometry.size.width, height: geometry.size.height).onAppear {
                            safeAreaBottom = geometry.safeAreaInsets.bottom
                        }
                    }
                }
            }
            VStack{
                VStack{
                    Spacer()
                    PlayerView(value: $vm.value, duration: $vm.duration).padding(.bottom, safeAreaBottom)
                }
            }.ignoresSafeArea()
        }
    }
}

#Preview {
    ContentView(vm: PlayerViewModel())
}
