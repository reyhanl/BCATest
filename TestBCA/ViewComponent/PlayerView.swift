//
//  PlayerView.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/29.
//
import SwiftUI

struct PlayerView: View {
    struct Action{
        var next: () -> Void
        var playPause: () -> Void
        var play: () -> Void
        var pause: () -> Void
        var previous: () -> Void
        var seek: (Int) -> Void
    }
    @Binding var value: Int
    @Binding var duration: Int
    @Binding var thumbnailImage: String
    @Binding var title: String
    @Binding var status: AudioPlayerStatus
    
    var actions: Action
    var body: some View {
        VStack{
            Group{
                HStack{
                    AsyncImage(url: URL(string: thumbnailImage)).aspectRatio(contentMode: .fit).frame(width: 50, height: 50).clipShape(RoundedRectangle(cornerRadius: 10))
                    Text(title).bold()
                    Spacer()
                    makeButton(imageName: "chevron.backward").onTapGesture {
                        actions.previous()
                    }
                    makeButton(imageName: status == .isPlaying ? "pause.fill":"play.fill").onTapGesture {
                        actions.playPause()
                    }
                    makeButton(imageName: "chevron.right").onTapGesture {
                        actions.next()
                    }
                }
                .padding(.top, 5)
                .padding(.bottom, status == .isLoading ? 5:0)
                if status != .isLoading && status != .failedToLoad{
                    HStack{
                        Text(value.durationStr)
                        SliderView(value: $value, duration: $duration, actions: .init(seek: { value in
                            actions.seek(value)
                        }, play: {
                            actions.play()
                        }, pause: {
                            actions.pause()
                        })).frame(height: 10)
                        Text(duration.durationStr)
                    }
                    .padding(.bottom, 5)
                }
            }
            .padding(.horizontal, 10)
            .if(status == .isLoading){ view in
                view.modifier(Shimmer())
            }
        }
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: Color.black.opacity(0.3), radius: 4, x: 2, y: 2)
    }
    
    @ViewBuilder func makeButton(imageName: String) -> some View{
        ZStack{
            Image(systemName: imageName).resizable().aspectRatio(contentMode: .fit).frame(width: 20, height: 20)
        }
    }
}
