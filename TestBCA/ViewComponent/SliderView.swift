//
//  SliderView.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/29.
//
import SwiftUI

struct SliderView: View {
    @Binding var value: Int
    @Binding var duration: Int
    var body: some View {
        HStack{
            GeometryReader{ geometry in
                HStack{
                    HStack{}.frame(width: CGFloat(value) / CGFloat(duration) * geometry.size.width, height: geometry.size.height)
                        .background(Color.primary)
                    Spacer()
                }.frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}
