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
    @State var offset: CGPoint = .zero
    @State var width: CGFloat = 0
    @State var isDragging: Bool = false
    struct Action{
        var seek: (Int) -> Void
        var play: () -> Void
        var pause: () -> Void
    }
    
    var actions: Action
    var body: some View {
        ZStack{
            HStack{
                GeometryReader{ geometry in
                    if #available(iOS 17.0, *) {
                        Color.clear.onAppear {
                            width = geometry.size.width
                        }.onChange(of: geometry.size.width) { oldValue, newValue in
                            width = geometry.size.width
                        }
                    } else {
                        Color.clear.onAppear {
                            width = geometry.size.width
                        }.onChange(of: geometry.size.width) { newValue in
                            width = geometry.size.width
                        }
                    }
                }
            }
            HStack{
                GeometryReader{ geometry in
                    HStack{
                        if isDragging{
                            HStack{}.frame(width: CGFloat(offset.x) / CGFloat(width) * geometry.size.width, height: geometry.size.height)
                                .background(Color.primary)
                        }else{
                            HStack{}.frame(width: CGFloat(value) / CGFloat(duration) * geometry.size.width, height: geometry.size.height)
                                .background(Color.primary)
                        }
                        if isDragging{
                            HStack{}.frame(width: CGFloat(width - offset.x) / CGFloat(width) * geometry.size.width, height: geometry.size.height)
                                .background(Color(UIColor.systemBackground))
                        }else{
                            HStack{}.frame(width: CGFloat(duration - value) / CGFloat(duration) * geometry.size.width, height: geometry.size.height)
                                .background(Color(UIColor.systemBackground))
                        }
                    }.frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
        }.gesture(
            DragGesture()
                .onChanged { value in
                    offset = value.location
                    isDragging = true
                    actions.pause()
                }
                .onEnded { _ in
                    isDragging = false
                    let maxDuration = duration
                    let newValue = Int((offset.x / width) * CGFloat(maxDuration))
                    actions.seek(newValue)
                    // You can reset or add custom logic here
                }
        )
        .onTapGesture(perform: { point in
            let maxDuration = duration
            let newValue = Int((point.x / width) * CGFloat(maxDuration))
            actions.seek(newValue)
        })
        .clipShape(Capsule()).overlay {
            Capsule().stroke(Color.primary, style: .init(lineWidth: 1))
        }
    }
}
