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

class PlayerViewModel: ObservableObject{
    @Published var value: Int = 0
    @Published var duration: Int = 10
    
    init() {
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
